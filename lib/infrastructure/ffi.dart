import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

String? getInstallDirFromRegistry() {
  final lpSubKey = r'SOFTWARE\WOW6432Node\Ubisoft\Anno 1800'.toNativeUtf16();
  final lpValue = r'InstallDir'.toNativeUtf16();

  final phKey = calloc<HKEY>();
  final lpType = calloc<Uint32>();
  final lpData = calloc<Uint8>(512);
  final lpcbData = calloc<Uint32>(1)..value = 512;

  try {
    var error = RegOpenKeyEx(HKEY_LOCAL_MACHINE, lpSubKey, 0, KEY_READ, phKey);
    if (error != ERROR_SUCCESS) {
      return null;
    }

    error = RegQueryValueEx(
        phKey.value, lpValue, nullptr, lpType, lpData, lpcbData);
    if (error != ERROR_SUCCESS) {
      return null;
    }

    final directory = lpData.cast<Utf16>().toDartString();
    return directory.isNotEmpty ? directory : null;
  } finally {
    free(phKey);
    free(lpSubKey);
    free(lpValue);
    free(lpType);
    free(lpData);
    free(lpcbData);
  }
}

String? promptAnnoDirectory() {
  final pfos = calloc<Uint32>();
  final ppsi = calloc<Pointer<COMObject>>();
  final pathPtrPtr = calloc<IntPtr>();

  var options = pfos.value;

  options |= FILEOPENDIALOGOPTIONS.FOS_PICKFOLDERS;
  options |= FILEOPENDIALOGOPTIONS.FOS_PATHMUSTEXIST;

  try {
    const dwCoInit = COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE;
    var hr = CoInitializeEx(nullptr, dwCoInit);
    final dialog = FileOpenDialog.createInstance();

    hr = dialog.setOptions(options);
    if (FAILED(hr)) {
      return null;
    }

    hr = dialog.show(NULL);
    if (FAILED(hr)) {
      return null;
    }

    hr = dialog.getResult(ppsi);
    final item = IShellItem(ppsi.cast());
    hr = item.getDisplayName(SIGDN.SIGDN_FILESYSPATH, pathPtrPtr.cast());
    if (FAILED(hr)) {
      return null;
    }

    final pathPtr = Pointer<Utf16>.fromAddress(pathPtrPtr.value);
    final path = pathPtr.toDartString();
    hr = item.release();
    if (FAILED(hr)) {
      return null;
    }

    return path;
  } finally {
    free(pfos);
    free(ppsi);
    free(pathPtrPtr);
  }
}
