use rand::Rng;
use std::io;

fn main() {
    println!("Guess the number!");
    let secret_number = rand::thread_rng().gen_range(1..=100);
    println!("The secret number is: {secret_number}");
    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin()
        .read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {guess}");
    bob(guess);

    // match guess.cmp(&secret_number) {
    //     std::cmp::Ordering::Less => println!("Too small!"),
    //     std::cmp::Ordering::Greater => println!("Too big!"),
    //     std::cmp::Ordering::Equal => println!("You win!"),
    // }
}

fn bob(h: String) {
    println!("{h}")
}
#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert_eq!(result, 4);
    }
}
