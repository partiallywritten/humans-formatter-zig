// to be used in https://pypi.org/project/humans-formatter/

const std = @import("std");


// func def timeFormatter: Formats time
// Arguments:
//  - zWriter: anytype - pass std.Io.Writer.fixed(&somebuffer) here. expected from WRAPS_timeFormatter
//  - MS: i64 - well its time in ms
//  - SHOULD_COMPOUND: bool - Compound formatting (i,e "1d 3m 2s"). Auto sets to true via wrapper WRAPS_timeFormatter
//  - SHOULD_ROUND: bool - Sets to true if needs rounding up. Not evaluated if SHOULD_COMPOUND set to true
pub fn timeFormatter(zWriter: anytype, MS: i64, SHOULD_COMPOUND: bool, SHOULD_ROUND: bool) !void{
    // what else am i supposed to do~~
    if (MS==0) {
        try zWriter.print("0ms", .{});
        return;
    }
    
    // std.time.ms_per_xxx is better but oh well
    const SECOND: u64 = 1000;
    const MINUTE: u64 = 60 * SECOND;
    const HOUR: u64 = 60 * MINUTE;
    const DAY: u64 = 24 * HOUR;
    
    const is_negative: bool = MS < 0;
    // better way is @abs but my zig version was outdated as i was writing this and just didnt want to use std.math
    // was that a good decision? no, do i regret writing this as is? no
    var casted_time: u64 = if (is_negative) (~@as(u64, @bitCast(MS)) + 1) else @intCast(MS);
    
    if (is_negative) try zWriter.writeByte('-');
    
    // compounding formatting
    if (SHOULD_COMPOUND) {
        const days: u64 = casted_time / DAY;
        casted_time -= days * DAY;
        
        const hours: u64 = casted_time / HOUR;
        casted_time -= hours * HOUR;
        
        const minutes: u64 = casted_time / MINUTE;
        casted_time -= minutes * MINUTE;
        
        const seconds: u64 = casted_time / SECOND;
        
        // yes i could've written tiny parts (ex: 1d) as i go through checks
        // but to keep the resulting string clean i have to do this
        // this output as follows:
        // xd xh xm xs
        // xh xm xs
        // xm xs
        // xs
        // xms
        // why? well this was intended to be used in my bots which are always I/O bound. What use does ms counter give in that situation?
        //       ms is there just in-case downloads gets stuck last bit (pun-intended) and needs to give the user some (false) hope
        if (days > 0) {
            try zWriter.print("{d}d {d}h {d}m {d}s", .{ days, hours, minutes, seconds });
        } else if (hours > 0) {
            try zWriter.print("{d}h {d}m {d}s", .{ hours, minutes, seconds });
        } else if (minutes > 0) {
            try zWriter.print("{d}m {d}s", .{ minutes, seconds });
        } else if (seconds > 0) {
            try zWriter.print("{d}s", .{ seconds });
        } else {
            try zWriter.print("{d}ms", .{ casted_time });
        }
        
    } else {
        
        // return largest unit only
        var value: u64 = casted_time;
        var suffix: []const u8 = "ms";
        var divisor: u64 = 1;
        
        if (value >= DAY) {divisor = DAY ; suffix = "d"; }
        else if (value >= HOUR) { divisor = HOUR ; suffix = "h"; }
        else if (value >= MINUTE) { divisor = MINUTE ; suffix = "m"; }
        else if (value >= SECOND) { divisor = SECOND ; suffix = "s"; }
        
        if (SHOULD_ROUND and divisor > 1) {
            value = (casted_time + (divisor / 2)) / divisor;
        } else {
            value = casted_time / divisor;
        }
        
        try zWriter.print("{d}{s}", .{ value, suffix });
        
    }
    
}

// func def: byteFormatter
// Arguments:
//  - zWriter: anytype - pass std.Io.Writer.fixed(&somebuffer) here. expected from WRAPS_byteFormatter
//  - SIZE: well its self explanatory isnt it?
pub fn byteFormatter(zWriter: anytype, SIZE: i64) !void {
	// what else am i supposed to do~~
    if (SIZE==0) {
        try zWriter.print("0 B", .{});
        return;
    }
    
    const units = [_][]const u8{"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
    var uindx: usize = 0;
    
    const is_negative: bool = SIZE < 0;
    const casted_size: u64 = if (is_negative) (~@as(u64, @bitCast(SIZE)) + 1) else @intCast(SIZE);
    var size_fcast: f64 = @floatFromInt(casted_size);
    
    while (size_fcast >= 1024.0 and uindx < units.len - 1) {
        size_fcast /= 1024.0;
        uindx += 1;
    }
    
    if (is_negative) try zWriter.writeByte('-');
    
    if (uindx == 0) { try zWriter.print("{d:.0} {s}", .{ size_fcast, units[uindx] }); }
    else { try zWriter.print("{d:.2} {s}", .{ size_fcast, units[uindx] }); }
}
