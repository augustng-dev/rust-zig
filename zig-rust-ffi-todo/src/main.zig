const std = @import("std");

pub extern "C" fn add(left: i32, right: i32) i32;

pub fn main() !void {
    std.debug.print("add({}, {}) = {}\n", .{
        1,
        2,
        add(1, 2),
    });
}