const std = @import("std");

const red = 12;
const green = 13;
const blue = 14;

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

pub fn helper(line: []const u8, part2: bool) u32 {
    var it = std.mem.splitAny(u8, line, ":");
    const game = it.first();
    var game_it = std.mem.splitAny(u8, game, " ");
    _ = game_it.first();
    var game_id: u32 = 0;
    while (game_it.next()) |x| {
        if (std.fmt.parseUnsigned(u32, x, 10)) |num| {
            game_id = num;
        } else |err| {
            std.debug.print("{}\n", .{err});
        }
    }
    const sets = it.next().?;
    var sets_it = std.mem.splitAny(u8, sets, ";");
    if (part2) {
        var min_red: u32 = 0;
        var min_green: u32 = 0;
        var min_blue: u32 = 0;
        while (sets_it.next()) |set| {
            var set_it = std.mem.splitAny(u8, set, ",");
            while (set_it.next()) |pair| {
                var pair_it = std.mem.splitAny(u8, pair, " ");
                _ = pair_it.first();
                const num_str = pair_it.next().?;
                if (pair_it.next()) |colour| {
                    if (std.fmt.parseUnsigned(u32, num_str, 10)) |num| {
                        if (std.mem.eql(u8, colour, "red")){
                            if (num > min_red) min_red = num;
                        } else if (std.mem.eql(u8, colour, "green")) {
                            if (num > min_green) min_green = num;
                        } else {
                            if (num > min_blue) min_blue = num;
                        }
                    } else |err| {
                        std.debug.print("{}\n", .{err});
                    }
                }
            }
        }
        return min_red * min_blue * min_green;
    } else {
        var b: bool = true;
        while (sets_it.next()) |set| {
            var set_it = std.mem.splitAny(u8, set, ",");
            while (set_it.next()) |pair| {
                var pair_it = std.mem.splitAny(u8, pair, " ");
                _ = pair_it.first();
                const num_str = pair_it.next().?;
                if (pair_it.next()) |colour| {
                    if (std.fmt.parseUnsigned(u32, num_str, 10)) |num| {
                        b = b and ((std.mem.eql(u8, colour, "red") and num <= red) 
                        or (std.mem.eql(u8, colour, "green") and num <= green) 
                        or (std.mem.eql(u8, colour, "blue") and num <= blue));
                    } else |err| {
                        std.debug.print("{}\n", .{err});
                    }
                }
            }
        }
        if (b) return game_id else return 0;
    }
    unreachable;
}