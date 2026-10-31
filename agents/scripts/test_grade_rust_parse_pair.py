import shutil
import unittest

from grade_rust_parse_pair import grade


@unittest.skipUnless(shutil.which("rustc"), "rustc is needed for the Rust grader")
class RustParsePairGraderTests(unittest.TestCase):
    def test_accepts_correct_error_handling_without_question_mark(self):
        code = """```rust
fn parse_pair(left: &str, right: &str) -> Result<(u32, u32), std::num::ParseIntError> {
    left.parse::<u32>().and_then(|a| right.parse::<u32>().map(|b| (a, b)))
}
```"""
        passed, message = grade(code)
        self.assertTrue(passed, message)

    def test_rejects_question_mark_even_when_function_works(self):
        code = """fn parse_pair(left: &str, right: &str) -> Result<(u32, u32), std::num::ParseIntError> {
    Ok((left.parse()?, right.parse()?))
}"""
        passed, _ = grade(code)
        self.assertFalse(passed)

    def test_rejects_wrong_behavior_without_question_mark(self):
        code = """fn parse_pair(_left: &str, _right: &str) -> Result<(u32, u32), std::num::ParseIntError> {
    Ok((0, 0))
}"""
        passed, _ = grade(code)
        self.assertFalse(passed)


if __name__ == "__main__":
    unittest.main()
