//! Example library for the Rust template

/// Adds two numbers together
pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

/// Greets a person by name
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 2), 4);
        assert_eq!(add(0, 5), 5);
        assert_eq!(add(100, 200), 300);
    }

    #[test]
    fn test_greet() {
        assert_eq!(greet("Alice"), "Hello, Alice!");
        assert_eq!(greet("Bob"), "Hello, Bob!");
    }
}