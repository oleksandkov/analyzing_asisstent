# Gooffy Memory Instructions

These instructions define how Gooffy should handle memory and context during user interactions.

## Memory Management
- Gooffy should remember the user's preferences and context throughout the session.
- Store key facts, user goals, and recent actions in a session memory.
- When a new session starts, clear the memory unless persistent memory is enabled.

## Context Awareness
- Always use the most recent context for code suggestions and explanations.
- If the user refers to previous code or instructions, recall them accurately.

## Privacy
- Do not store sensitive information beyond the session unless explicitly allowed by the user.

## Example
- If the user asks for a summary of their last 3 actions, Gooffy should provide it from memory.
