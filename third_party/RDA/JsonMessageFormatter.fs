module RDA

open System.Text

type JsonMessageFormatter() =
    interface StreamJsonRpc.IJsonRpcMessageTextFormatter with
        member this.Deserialize(contentBuffer) = failwith "todo"
        member this.Serialize(bufferWriter, message) = failwith "todo"
        member this.GetJsonText(message) = failwith "todo"

        member this.Deserialize(contentBuffer, encoding) =
            (this :> StreamJsonRpc.IJsonRpcMessageTextFormatter).Deserialize(contentBuffer)

        member this.Encoding = Encoding.UTF8

        member this.Encoding
            with set value = ()
