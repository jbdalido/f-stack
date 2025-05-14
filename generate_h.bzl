def _emit_rules(mfiles, script, flag, suffix_func):
    for mfile in mfiles:
        base = mfile.split("/")[-1].rsplit(".", 1)[0]
        out = suffix_func(base)
        name = "{}_{}_generated".format(base, flag)

        native.genrule(
            name = name,
            srcs = [mfile, script],
            outs = [out],
            cmd = """
                awk -f $(location {script}) $(location {mfile}) -{flag}
                mv {out} $@
            """.format(script = script, mfile = mfile, flag = flag, out = out),
            visibility = ["//visibility:public"],
        )

def make_ch_genrules(typedef_files = [], h_files = [], c_files = [], newproto_files = [], script = ""):
    if not script:
        fail("You must specify the awk script path via 'script'")

    _emit_rules(typedef_files, script, "q", lambda base: "{}_typedef.h".format(base))
    _emit_rules(h_files, script, "h", lambda base: "{}.h".format(base))
    _emit_rules(c_files, script, "c", lambda base: "{}.c".format(base))
    _emit_rules(newproto_files, script, "p", lambda base: "{}_newproto.h".format(base))