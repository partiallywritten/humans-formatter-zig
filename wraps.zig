// reserved
// c wraps

const std = @import("std");
const use_Formatters = @import("utils.zig");

// Supports 3.10+
const py = @cImport({
    @cDefine("Py_LIMITED_API", "0x030A0000");
    @cInclude("Python.h");
});


// wrapper for time formatter
export fn WRAPS_timeFormatter(self: ?*py.PyObject, args: ?*py.PyObject) ?*py.PyObject {
	// [_:null]?[*:0]const u8{...} supposed to be better but im not good enough to cast it so it could be used in py
	var kwlist = [_][*c]const u8 { "ms", "round", "compound", null };
	
	// defaults
	var ms: i64 = 0;
	var round: i32 = 0;
	var compound: i32 = 0;
	
	// L - required ; p - optional
	// @ptrCast(&kwlist) - C ask for ptr to 1st item then goes til it finds null. Dammit i need to learn C now
    if (py.PyArg_ParseTupleAndKeywords(args, kwargs, "L|pp", @ptrCast(&kwlist), &ms, &round_val, &compound) == 0) {
        return null;
    }

    var buf: [128]u8 = undefined;
    var writer = std.Io.Writer.fixed(&buf);

    use_Formatters.timeFormatter(writer, ms, round_val != 0, compound != 0) catch return null;

    return py.PyUnicode_FromStringAndSize(@ptrCast(&buf), @intCast(writer.end));
}

// wrapper for byte formatter
export fn WRAPS_byteFormatter(self: ?*py.PyObject, args: ?*py.PyObject) ?*py.PyObject {
    var size: i64 = 0;
    if (py.PyArg_ParseTuple(args, "L", &size) == 0) return null;

    var buf: [64]u8 = undefined;
    var writer = std.Io.Writer.fixed(&buf);
    
    use_Formatters.byteFormatter(writer, size) catch return null;

    return py.PyUnicode_FromStringAndSize(@ptrCast(&buf), @intCast(writer.end));
}
