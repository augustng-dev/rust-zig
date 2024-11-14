// Various types of fibonacci written in zig
const std = @import("std");
const math = @import("std").math;

pub fn zignacci(n: usize, memo: *std.AutoHashMap(usize, u64)) !u64 {
    if (memo.get(n)) |result| {
        return result;
    }

    var result: u64 = 0;
    if (n <= 2) {
        result = 1;
    } else {
        result = try zignacci(n - 2, memo) + try zignacci(n - 1, memo);
    }

    try memo.put(n, result);
    return result;
}

// Recursive 
fn recursive(n: u64) u64 {
    if (n < 2) {
        return n;
    }
    return recursive(n - 1) + recursive(n - 2);
}

fn tailRecursive(n: u64, acc: u64, prev: u64) u64 {
    if( n < 1) {
        return acc;
    } else{
        return tailRecursive(n - 1, prev + acc, acc);
    }
}

// const phi: f64 = (1.0 + math.sqrt(5.0)) / 2.0;
// fn binetFormula(n: u32) u64 {
//     return (math.pow(phi, n) - math.pow(1.0 - phi, n)) / math.sqrt(5.0);
// }

pub fn main() !void {
    const num: u64 = 30;
    var memo = std.AutoHashMap(usize, u64).init(std.heap.page_allocator);
    defer memo.deinit();
    const n = try zignacci(num, &memo);
    std.debug.print("zignacci({}) results in {}\n", .{num, n});

    const recursiveResult = recursive(num);
    const tailRecursiveResult = tailRecursive(num, 0, 1);

    std.debug.print("recursive({}) results in {}\n", .{num, recursiveResult});
    std.debug.print("tailRecursive({}) results in {}\n", .{num, tailRecursiveResult});
    // std.debug.print("binetFormula({}) results in {}\n", .{num, binetFormula});
}