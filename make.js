// X1.ASZ の INCLUDE を まとめて ZASM/X1.ASM に保存する WSHスクリプト

var fso = WScript.CreateObject("Scripting.FileSystemObject");
var sASZ = ReadFile("X1.ASZ").replace(/\s*INCLUDE\s+"([^"]+)"/g, IncludeFile);
var fh = fso.OpenTextFile("ZASM\\X1.ASM", 2, true, 0);
fh.Write(sASZ);
fh.Close();

function IncludeFile(sMatch, ref) {
    return "\n;" + ref + "\n" + ReadFile(ref);
}

function ReadFile(fn) {
    var fh = fso.OpenTextFile(fn, 1, false, 0);
    var s = fh.ReadAll();
    fh.Close();
    return s.replace(/\x1a$/, "");
}
