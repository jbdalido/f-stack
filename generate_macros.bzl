load("@rules_cc//cc:find_cc_toolchain.bzl", "find_cc_toolchain")

def _gen_filtered_macros_impl(ctx):
    cc_toolchain = find_cc_toolchain(ctx)
    compiler = cc_toolchain.compiler_executable
    ctx.actions.run_shell(
        outputs = [ctx.outputs.out],
        inputs = cc_toolchain._compiler_files,
        command = """
        "${COMPILER}" -E -dM - < /dev/null | grep -v -E '__STDC__|__STDC_HOSTED__|__STDC_VERSION__|__APPLE__|__MACH__|__CYGWIN__|__CYGWIN32__|__FreeBSD__|__linux|__linux__|__gnu__linux__|linux|_WIN32|_WIN64' > "$OUT"
        """,
        env = {
            "COMPILER": compiler,
            "OUT": ctx.outputs.out.path,
        },
        mnemonic = "GenFilteredMacros",
    )

gen_filtered_macros = rule(
    implementation = _gen_filtered_macros_impl,
    outputs = {"out": "lib/%{name}.h"},
    toolchains = ["@rules_cc//cc:toolchain_type"],
    attrs = {},
    doc = "Generates a header file with filtered predefined macros from the current C++ toolchain",
)