# Contributing to Glide Docking Pipeline

Thank you for considering contributing to this project! 🎉

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- **Clear title** describing the problem
- **Steps to reproduce** the issue
- **Expected behavior** vs actual behavior
- **Environment details** (OS, Schrodinger version, bash version)
- **Error messages** or log outputs

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:
- **Use case** - Why is this enhancement needed?
- **Proposed solution** - How should it work?
- **Alternatives considered** - Other approaches you thought about

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

#### Pull Request Guidelines

- Follow existing code style
- Update README.md if adding features
- Test on your local environment
- Include examples if adding new functionality

## Code Style

### Bash Script Conventions

- Use `#!/bin/bash` shebang
- Add `set -e` for error handling
- Use meaningful variable names (UPPERCASE for constants)
- Comment complex logic
- Include usage examples in headers

### Example

```bash
#!/bin/bash
################################################################################
# SCRIPT NAME
# Brief description of what it does
################################################################################

set -e  # Exit on error

# Configuration
CONSTANT_VAR="value"

# Function with clear name
do_something() {
    local param=$1
    echo "Processing: $param"
}
```

## Testing

Before submitting:

1. Test with sample data
2. Verify on target OS (Linux/macOS/Windows)
3. Check all error messages are helpful
4. Ensure cleanup happens on exit

## Documentation

- Update README.md for new features
- Add inline comments for complex code
- Include examples where helpful

## Questions?

Open an issue with the `question` label or email [your.email@example.com]

## Code of Conduct

- Be respectful and constructive
- Help others learn
- Give credit where due
- Keep discussions focused and professional

Thank you for your contributions! 🙏
