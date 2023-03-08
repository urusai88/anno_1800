module Program

open System
open System.IO
open System.Reflection
open System.Runtime.InteropServices
open System.Text
open System.Text.RegularExpressions
open FileDBReader
open FileDBReader.src
open FileDBReader.src.XmlRepresentation
open Newtonsoft.Json
open RDAExplorer
open StreamJsonRpc

let assembly = Assembly.GetExecutingAssembly()

let rdaIgnoreList =
    [ "0"; "1"; "2"; "3"; "4"; "7"; "8"; "9"; "17"; "18"; "19"; "20"; "23" ]

let extensionList = [ "a7tinfo"; "a7minfo"; "a7t"; "a7te"; "png"; "xml" ]

type DelegateExtract = delegate of string -> (string -> bool)

type ProgressStep =
    | Reading = 0
    | Computing = 1
    | Copying = 2

let reportError (error: string) =
    JsonConvert.SerializeObject({| error = error |}) |> printfn "%s"

let reportProgress (rpc: JsonRpc) (step: ProgressStep) (a: int) (b: int) : Async<unit> =
    rpc.NotifyAsync("extract_progress", {| step = step; a = a; b = b |})
    |> Async.AwaitTask

let reportReading (rpc: JsonRpc) (a: int) (b: int) =
    reportProgress rpc ProgressStep.Reading a b

let reportComputing (rpc: JsonRpc) (a: int) (b: int) =
    reportProgress rpc ProgressStep.Computing a b

let reportCopying (rpc: JsonRpc) (a: int) (b: int) =
    reportProgress rpc ProgressStep.Copying a b

let extract (maindataPath: string, outputDirectory: string, rpc: JsonRpc) =
    UISettings.EnableConsole <- false

    let mDi = DirectoryInfo(maindataPath)
    let oDi = DirectoryInfo(outputDirectory)

    if not mDi.Exists || not oDi.Exists then
        false
    else
        let rdaContains x = List.contains x rdaIgnoreList
        let extensionContains x = List.contains x extensionList

        let rdaFiles: FileInfo seq =
            mDi.EnumerateFiles()
            |> Seq.where (fun x -> Path.GetExtension(x.FullName) = ".rda")
            |> Seq.where (fun x -> Path.GetFileName(x.FullName).StartsWith("data"))
            |> Seq.where (fun x -> Path.GetFileNameWithoutExtension(x.FullName)[4..] |> rdaContains |> not)
            |> Seq.sortBy (fun x -> Path.GetFileNameWithoutExtension(x.FullName)[4..] |> int)

        let readers: RDAReader[] =
            [| for rdaFile in rdaFiles do
                   new RDAReader(FileName = rdaFile.FullName) |]

        let mutable progress = 0
        let length = Array.length readers

        reportReading rpc progress length |> Async.RunSynchronously

        let tasks: Async<unit>[] =
            [| for reader in readers do
                   async {
                       reader.ReadRDAFile()
                       progress <- progress + 1
                       do! reportReading rpc progress length
                   } |]

        Async.Parallel tasks |> Async.RunSynchronously |> ignore

        let mutable progress = 0

        reportComputing rpc progress length |> Async.RunSynchronously

        let regEx =
            Regex(
                @"^data\/((dlc\d+)\/)?sessions\/(islands|maps)\/(pool|land_of_lions|colony_03_sp|sunken_treasures)\/[^\.]*\.(a7tinfo|a7minfo|a7t|a7m|a7te|png|xml)"
            )

        let map: (RDAReader * RDAFile[])[] =
            readers
            |> Array.map (fun reader ->
                let files =
                    reader.rdaFolder.GetAllFiles()
                    |> Seq.where (fun x -> regEx.Match(x.FileName).Success)
                    // |> Seq.where (fun x -> Path.GetExtension(x.FileName).Length > 1)
                    // |> Seq.where (fun x -> Path.GetExtension(x.FileName)[1..] |> extensionContains)
                    |> Seq.toArray

                progress <- progress + 1
                reportComputing rpc progress length |> Async.RunSynchronously
                reader, files)

        let fileMap: Map<string, RDAFile * RDAReader> =
            map
            |> Array.collect (fun e ->
                let reader = fst e
                let files = snd e
                // transforms "RDAReader * RDAFile[]" to "(string * (RDAFile * RDAReader))[]"
                files |> Array.map (fun x -> x.FileName, (x, reader)))
            |> Map.ofArray<string, RDAFile * RDAReader>

        let mutable progress = 0
        let length = Map.count fileMap

        reportCopying rpc progress length |> Async.RunSynchronously

        (*let f = @"C:\Users\Urusai\Desktop\anno\anno_launcher\txt.txt"

        File.Delete(f)

        for file in fileMap.Keys do
            File.AppendAllText(f, file + "\n")*)

        let reader = Reader()

        use tinfoStream = assembly.GetManifestResourceStream("RDA.FileFormats.a7tinfo.xml")
        use minfoStream = assembly.GetManifestResourceStream("RDA.FileFormats.a7minfo.xml")

        let tinfoInterpreter = Interpreter(Interpreter.ToInterpreterDoc(tinfoStream))
        let minfoInterpreter = Interpreter(Interpreter.ToInterpreterDoc(minfoStream))

        let xmlInterpreter = XmlInterpreter()
        let out = Console.Out

        for file in fileMap do
            let filename = file.Key
            let rdaFile = fst (file.Value)
            let rdaReader = snd (file.Value)
            let path = Path.Combine(outputDirectory, filename)
            let folder = DirectoryInfo(Path.GetDirectoryName(path))

            if not folder.Exists then
                folder.Create()

            if not (File.Exists(path)) then
                let ext = Path.GetExtension(path)[1..]
                let data = rdaFile.GetData()
                use stream = File.OpenWrite(path)

                match ext with
                | "png" -> stream.Write(data)
                | "a7minfo" ->
                    Console.SetOut(TextWriter.Null)
                    use memory = new MemoryStream(rdaFile.GetData())
                    let xml = reader.Read(memory)
                    let xml = xmlInterpreter.Interpret(xml, minfoInterpreter)
                    xml.Save(stream)
                    Console.SetOut(out)
                | "a7tinfo" ->
                    Console.SetOut(TextWriter.Null)
                    use memory = new MemoryStream(rdaFile.GetData())
                    let xml = reader.Read(memory)
                    let xml = xmlInterpreter.Interpret(xml, tinfoInterpreter)
                    xml.Save(stream)
                    Console.SetOut(out)
                | _ -> stream.Write(data)

            progress <- progress + 1

            if progress % 100 = 0 then
                reportCopying rpc progress length |> Async.RunSynchronously

        reportCopying rpc length length |> Async.RunSynchronously

        let fileList = fileMap |> Map.keys
        let json = JsonConvert.SerializeObject(fileList)
        let bytes = Encoding.UTF8.GetBytes(json)
        let jsonFile = Path.Combine(outputDirectory, "map.json")

        let writeMapJsonFile _ =
            if File.Exists(jsonFile) then
                File.Delete(jsonFile)

            use stream = File.OpenWrite(jsonFile)
            stream.Write(bytes)

        writeMapJsonFile ()

        true

let reportProgress1 (step: ProgressStep) (a: int) (b: int) : unit =
    JsonConvert.SerializeObject({| step = step; current = a; total = b |}) |> printfn "%s"

let reportReading1 (a: int) (b: int) : unit =
    reportProgress1 ProgressStep.Reading a b

let reportComputing1 (a: int) (b: int) : unit =
    reportProgress1 ProgressStep.Computing a b

let reportCopying1 (a: int) (b: int): unit =
    reportProgress1 ProgressStep.Copying a b

let extract1 (i: string) (o: string) : unit =
    UISettings.EnableConsole <- false

    let mDi = DirectoryInfo(i)
    let oDi = DirectoryInfo(o)
    
    let reportDirectoryError _ = 
        if not mDi.Exists then
            reportError $"%s{i} does not exists"
        else
            reportError $"%s{o} does not exists"

    if not mDi.Exists || not oDi.Exists then
        reportDirectoryError()
    else
        let rdaContains x = List.contains x rdaIgnoreList
        let extensionContains x = List.contains x extensionList

        let rdaFiles: FileInfo seq =
            mDi.EnumerateFiles()
            |> Seq.where (fun x -> Path.GetExtension(x.FullName) = ".rda")
            |> Seq.where (fun x -> Path.GetFileName(x.FullName).StartsWith("data"))
            |> Seq.where (fun x -> Path.GetFileNameWithoutExtension(x.FullName)[4..] |> rdaContains |> not)
            |> Seq.sortBy (fun x -> Path.GetFileNameWithoutExtension(x.FullName)[4..] |> int)

        let readers: RDAReader[] =
            [| for rdaFile in rdaFiles do
                   new RDAReader(FileName = rdaFile.FullName) |]

        let mutable progress = 0
        let length = Array.length readers

        reportReading1 progress length //  |> Async.RunSynchronously

        let tasks: Async<unit>[] =
            [| for reader in readers do
                   async {
                       reader.ReadRDAFile()
                       progress <- progress + 1
                       reportReading1 progress length
                   } |]

        Async.Parallel tasks |> Async.RunSynchronously |> ignore

        let mutable progress = 0

        reportComputing1 progress length//  |> Async.RunSynchronously

        let regEx =
            Regex(
                @"^data\/((dlc\d+)\/)?sessions\/(islands|maps)\/(pool|land_of_lions|colony_03_sp|sunken_treasures)\/[^\.]*\.(a7tinfo|a7minfo|a7t|a7m|a7te|png|xml)"
            )

        let map: (RDAReader * RDAFile[])[] =
            readers
            |> Array.map (fun reader ->
                let files =
                    reader.rdaFolder.GetAllFiles()
                    |> Seq.where (fun x -> regEx.Match(x.FileName).Success)
                    |> Seq.toArray

                progress <- progress + 1
                reportComputing1 progress length// |> Async.RunSynchronously
                reader, files)

        let fileMap: Map<string, RDAFile * RDAReader> =
            map
            |> Array.collect (fun e ->
                let reader = fst e
                let files = snd e
                // transforms "RDAReader * RDAFile[]" to "(string * (RDAFile * RDAReader))[]"
                files |> Array.map (fun x -> x.FileName, (x, reader)))
            |> Map.ofArray<string, RDAFile * RDAReader>

        let mutable progress = 0
        let length = Map.count fileMap

        reportCopying1 progress length // |> Async.RunSynchronously

        let reader = Reader()

        use tinfoStream = assembly.GetManifestResourceStream("RDA.FileFormats.a7tinfo.xml")
        use minfoStream = assembly.GetManifestResourceStream("RDA.FileFormats.a7minfo.xml")

        let tinfoInterpreter = Interpreter(Interpreter.ToInterpreterDoc(tinfoStream))
        let minfoInterpreter = Interpreter(Interpreter.ToInterpreterDoc(minfoStream))

        let xmlInterpreter = XmlInterpreter()
        let out = Console.Out

        for file in fileMap do
            let filename = file.Key
            let rdaFile = fst (file.Value)
            let rdaReader = snd (file.Value)
            let path = Path.Combine(o, filename)
            let folder = DirectoryInfo(Path.GetDirectoryName(path))

            if not folder.Exists then
                folder.Create()

            if not (File.Exists(path)) then
                let ext = Path.GetExtension(path)[1..]
                let data = rdaFile.GetData()
                use stream = File.OpenWrite(path)

                match ext with
                | "png" -> stream.Write(data)
                | "a7minfo" ->
                    Console.SetOut(TextWriter.Null)
                    use memory = new MemoryStream(rdaFile.GetData())
                    let xml = reader.Read(memory)
                    let xml = xmlInterpreter.Interpret(xml, minfoInterpreter)
                    xml.Save(stream)
                    Console.SetOut(out)
                | "a7tinfo" ->
                    Console.SetOut(TextWriter.Null)
                    use memory = new MemoryStream(rdaFile.GetData())
                    let xml = reader.Read(memory)
                    let xml = xmlInterpreter.Interpret(xml, tinfoInterpreter)
                    xml.Save(stream)
                    Console.SetOut(out)
                | _ -> stream.Write(data)

            progress <- progress + 1

            if progress % 100 = 0 then
                reportCopying1 progress length//  |> Async.RunSynchronously

        reportCopying1 length length// |> Async.RunSynchronously

        let fileList = fileMap |> Map.keys
        let json = JsonConvert.SerializeObject(fileList)
        let bytes = Encoding.UTF8.GetBytes(json)
        
        let jsonFile = Path.Combine(o, "sessions.json")

        let writeMapJsonFile _ =
            if File.Exists(jsonFile) then
                File.Delete(jsonFile)

            use stream = File.OpenWrite(jsonFile)
            stream.Write(bytes)

        writeMapJsonFile ()
        
        printfn "done"

        ()

let extractSessions (args: string[]) =
    let getOption (optionName: string) =
        args
        |> Array.where (fun s -> s.StartsWith(optionName))
        |> Array.tryItem 0
        |> Option.map (fun s -> s.Substring(optionName |> String.length))
    
    let mainDataPath = getOption "-i="
    let outputPath = getOption "-o="

    match mainDataPath, outputPath with
    | Some i, Some o -> extract1 i o
    | _ -> reportError "no -o or -i option"

    0

[<EntryPoint>]
let main (args: string[]) =
    match args |> Array.tryItem 0 with
    | Some "extract_sessions" -> extractSessions (args.[1..]) |> ignore
    | _ -> ()

    (*
    let sending = Console.OpenStandardOutput()
    let receiving = Console.OpenStandardInput()
    let formatter = RDA.JsonMessageFormatter() :> IJsonRpcMessageTextFormatter
    let formatter = new JsonMessageFormatter()

    let messageHandler =
        new NewLineDelimitedMessageHandler(sending, receiving, formatter)

    messageHandler.NewLine <- NewLineDelimitedMessageHandler.NewLineStyle.Lf

    let rpc = new JsonRpc(messageHandler)

    rpc.AddLocalRpcMethod("extract", Func<string, string, bool>(fun a b -> extract (a, b, rpc)))
    rpc.AddLocalRpcMethod("pack_a7minfo", Func<bool>(fun _ -> pack ()))
    rpc.StartListening()

    async { do! rpc.Completion |> Async.AwaitTask } |> Async.RunSynchronously
    *)

    0
