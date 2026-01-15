# AGENTS.md

This file contains guidelines and commands for agentic coding agents working in this repository.

## Build/Lint/Test Commands

### Shell Script Formatting and Linting
```bash
# Format all shell scripts in the gold/ directory
make format

# Individual formatting commands
shfmt --write --list --indent 4 --case-indent --space-redirects ./gold/<script>
shellcheck ./gold/<script> --enable all
dos2unix ./gold/<script>
```

### Testing
This repository uses functional testing rather than unit tests. To test changes:

1. **Verify script functionality**: Run the modified script in a container or environment
2. **Check dependencies**: Ensure `requires` calls are satisfied
3. **Validate formatting**: Run `make format` to ensure proper formatting
4. **Shellcheck compliance**: No new shellcheck issues should be introduced

### Single Script Testing
```bash
# Test a specific installation script
./gold/install_<tool>

# Test utility functions
./gold/is_command <command>
./gold/is_installed <package>
./gold/requires <dependency1> <dependency2>
```

## Code Style Guidelines

### Shell Script Structure
- **Shebang**: All scripts must start with `#! /bin/bash`
- **Error handling**: Include `set -e` at the top of every script
- **Main function**: Use `main()` function as entry point
- **Function calls**: End scripts with `main "$@"`

### Function Naming and Structure
- **Descriptive names**: Use snake_case for function names (e.g., `install_docker`)
- **Local variables**: Declare variables with `local` inside functions
- **Constants**: Use UPPER_CASE for constants (e.g., `NVIDIA_URL`)
- **Comments**: Use `#` for comments, add section headers with `#` repeated

### Variable Handling
- **Quoting**: Always quote variables: `"${VAR}"` not `$VAR`
- **Parameter expansion**: Use `"${1:-"default"}"` for defaults
- **Arrays**: Use proper array syntax: `ARGS=("$@")`
- **Color codes**: Define color variables at function scope

### Error Handling and Dependencies
- **Dependency checking**: Use `requires <dependency>` at script start
- **Command validation**: Use `is_command <command>` before using commands
- **Graceful failures**: Use meaningful error messages with color coding
- **Signal handling**: Use `kill -SIGINT $$` for critical errors

### Shellcheck Directives
- **Inline disables**: Use `# shellcheck disable=SC<code>` for necessary exceptions
- **Common disables**:
  - `SC2016`: For single quotes in echo statements
  - `SC2059`: For printf with color variables
  - `SC2312`: Global disable (configured in .shellcheckrc)

### Import and Source Handling
- **Sourcing**: Use `# shellcheck source=/dev/null` for sourcing system files
- **Path handling**: Use absolute paths for system files (`/etc/os-release`)
- **Environment**: Source environment files safely

### Formatting Standards (shfmt configuration)
- **Indentation**: 4 spaces
- **Case indentation**: Enabled
- **Redirect spacing**: Space around redirects (`>`, `>>`, `<`)
- **Line endings**: Unix-style (use dos2unix)

### Package Installation Patterns
- **APT packages**: Use `--no-install-recommends --yes` flags
- **Service management**: Enable and start services appropriately
- **Cleanup**: Remove temporary files and caches
- **Updates**: Run `apt-get update` before installations

### Documentation and Comments
- **Function purpose**: Add comment blocks describing function purpose
- **External references**: Include URLs for external documentation
- **Workarounds**: Document any workarounds with `WORKAROUND` label
- **Section headers**: Use `#` repeated for visual separation

### File Organization
- **Utility functions**: Place in root of gold/ directory
- **Installation scripts**: Prefix with `install_`
- **Start scripts**: Prefix with `start_`
- **Download scripts**: Prefix with `download_`

### Cross-Platform Considerations
- **Container compatibility**: Scripts should work in containers
- **Privilege requirements**: Document when `--privileged` is needed
- **Path assumptions**: Avoid hardcoding paths when possible
- **Command availability**: Check for command existence before use

## Development Workflow

1. **Create new script**: Follow naming conventions and structure
2. **Add to Makefile**: Include new script in GOLD variable if needed
3. **Test functionality**: Verify script works in target environment
4. **Format and lint**: Run `make format` to ensure compliance
5. **Update documentation**: Add script to README.md if user-facing

## Repository Structure Notes

- **gold/**: Contains all shell scripts and utilities
- **Configuration files**: Organized by application in subdirectories
- **Makefile**: Defines formatting targets and script lists
- **.shellcheckrc**: Global shellcheck configuration
- **No test files**: Uses functional testing approach

## Common Patterns

### Dependency Checking
```bash
requires curl
requires wget
```

### Command Existence
```bash
if is_command nvidia-smi; then
    install_nvidia_container_toolkit
fi
```

### Error Messages
```bash
local NC='\033[0m'
local RED='\033[0;31m'
printf "${RED}==> [ERROR]${NC} Message\n"
```

### Service Management
```bash
systemctl enable docker.service
systemctl start docker.service
```