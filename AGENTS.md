<!-- CODEX_LEAN_TEAM_V1_START -->
# Lean adaptive engineering workflow

Work directly for small, clear, localized tasks.

Delegate only when delegation is likely to improve correctness:
- Use `lean-planner` for ambiguous, architectural, cross-module, or high-blast-radius work.
- Use `lean-reviewer` after non-trivial changes, public API changes, concurrency, migrations, security-sensitive code, or unclear bug fixes.
- Use `lean-performance` only for measured performance work, native hot paths, SIMD/GPU code, or benchmark-sensitive changes.
- Use `lean-ai-ml` only for model inference, training, quantization, RAG, OCR, TTS, CUDA, Metal, MLX, llama.cpp, or vLLM.
- Use `lean-infrastructure` only for deployment, CI/CD, containers, networking, cloud, observability, or reliability.

Do not invoke multiple agents for trivial edits.
Do not delegate the same analysis twice.
Prefer one focused specialist over broad fan-out.
Keep `max_depth = 1`; subagents must not recursively create teams.

Before editing:
1. Detect the repository languages, frameworks, build systems, and conventions.
2. Read the nearest relevant code and project instructions.
3. Use ecosystem-native patterns; do not force C-style solutions onto managed languages.
4. Preserve backward compatibility unless the task explicitly changes it.

Before completion:
1. Run the smallest relevant validation set.
2. State exactly what was tested and what was not.
3. For non-trivial work, request one focused review pass.
<!-- CODEX_LEAN_TEAM_V1_END -->
