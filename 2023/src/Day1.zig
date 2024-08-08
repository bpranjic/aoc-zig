const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var res1: u32 = 0;
    var res2: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        res1 += helper(line, false);
        res2 += helper(line, true);
    }
    std.debug.print("Part 1: {d}\n", .{res1});
    std.debug.print("Part 2: {d}\n", .{res2});
}

pub fn helper(line: []u8, part2: bool) u32 {
    var sum: u32 = 0;
    var first_digit: ?u8 = null;
    var last_digit: ?u8 = null;
    const numbers = [9][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    // find first digit
    for (line, 0..) |c, i| {
        if (std.ascii.isDigit(c)) {
            first_digit = @intCast(c - '0');
        }
        if (part2) {
            for (numbers, 1..) |num_str, num_idx| {
                if (std.mem.startsWith(u8, line[i..], num_str)) {
                    first_digit = @intCast(num_idx);
                    break;
                }
            }
        }
        if (first_digit) |num| {
            sum += num * 10;
            break;
        }
    }

    // find last digit by iterating slice from the back
    var it = line.len;
    while (it > 0) {
        it -= 1;
        const c = line[it];
        if (std.ascii.isDigit(c)) {
            last_digit = @intCast(c - '0');
        }
        if (part2) {
            for (numbers, 1..) |num_str, num_idx| {
                if (it < num_str.len) continue;
                if (std.mem.startsWith(u8, line[(it - num_str.len)..], num_str)) {
                    last_digit = @intCast(num_idx);
                    break;
                }
            }
        }
        if (last_digit) |num| {
            sum += num;
            break;
        }
    }
    return sum;
}
