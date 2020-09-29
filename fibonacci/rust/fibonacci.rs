use std::env;
use std::time::{SystemTime};

fn recursive_fibonacci (n: i32) -> i32 {
    if n < 1 {
        0
    } else if n == 1 {
        1
    } else {
        recursive_fibonacci(n - 1) + recursive_fibonacci(n - 2)
    }
}

fn main () {
    // https://doc.rust-lang.org/book/ch12-01-accepting-command-line-arguments.html
    let args: Vec<String> = env::args().collect();
    // https://doc.rust-lang.org/std/primitive.str.html#method.parse
    let n = args[1].parse::<i32>().unwrap();
    println!("{}", n);

    // https://doc.rust-lang.org/std/time/struct.SystemTime.html
    let start = SystemTime::now();

    println!("{}", recursive_fibonacci(n));

    let dur = SystemTime::now()
        .duration_since(start)
        .expect("Time went backwards");

    println!("{}", (dur.as_secs() * 1_000) + dur.subsec_millis() as u64)
}
