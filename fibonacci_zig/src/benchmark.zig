const std = @import("std");

pub fn benchmark() !void {
    const allocator = std.heap.page_allocator;

    // Định nghĩa một benchmark
    const bench = std.bench.Benchmark{
        .name = "example_benchmark",
        .fn = exampleBenchmark,
    };

    // Chạy benchmark
    const result = try std.bench.run(allocator, &bench);
    std.debug.print("Benchmark result: {}\n", .{result});
}

fn exampleBenchmark(bencher: *std.bench.Bencher) !void {
    // Cách sử dụng bencher để đo thời gian
    try bencher.run("example_task", exampleTask);
}

fn exampleTask() void {
    // Công việc bạn muốn đo hiệu suất
    var sum: u64 = 0;
    for (i in 0..1_000_000) {
        sum += i;
    }
    // Đảm bảo biến sum được sử dụng để ngăn compiler tối ưu hóa
    std.debug.assert(sum == 499999500000);
}

pub fn main() !void {
    try benchmark();
}