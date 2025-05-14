def _generate_build_config_impl(ctx):
    substitutions = {
        "{RTE_MAX_LCORE}": "128",
        "{RTE_MAX_NUMA_NODES}": "4",
        "{RTE_MAX_ETHPORTS}": ctx.attr.max_ethports,
        "{RTE_PKTMBUF_HEADROOM}": ctx.attr.pkt_mbuf_headroom,
        "{RTE_MAX_MEM_MB}": "524288" if ctx.attr.arch_64 else "2048",
        "{RTE_LIBEAL_USE_HPET}": "1" if ctx.attr.use_hpet else "0",
        "{RTE_EAL_VFIO}": "1" if ctx.attr.is_linux else "0",
        "{RTE_MAX_VFIO_GROUPS}": "64",
        "{RTE_DRIVER_MEMPOOL_BUCKET_SIZE_KB}": "64",
        "{RTE_EAL_PMD_PATH}": ctx.attr.pmd_path,
        "{RTE_ARCH}": ctx.attr.arch,
        "{RTE_ARCH_64}": "1" if ctx.attr.arch_64 else "0",
        "{RTE_ARCH_32}": "0" if ctx.attr.arch_64 else "1",
        "{RTE_MACHINE}": ctx.attr.machine,
        "{RTE_COMPILE_TIME_CPUFLAGS}": ctx.attr.compile_time_cpuflags,
        "{RTE_BACKTRACE}": "1" if ctx.attr.backtrace else "0",
        "{RTE_ENABLE_STDATOMIC}": "1" if ctx.attr.enable_stdatomic else "0",
        "{RTE_ENABLE_TRACE_FP}": "1" if ctx.attr.enable_trace_fp else "0",
        "{RTE_EXEC_ENV}": "1" if ctx.attr.is_linux else ("2" if ctx.attr.is_windows else "0"),
        "{RTE_EXEC_ENV_IS_LINUX}": "1" if ctx.attr.is_linux else "0",
        "{RTE_EXEC_ENV_IS_FREEBSD}": "0",
        "{RTE_EXEC_ENV_IS_WINDOWS}": "1" if ctx.attr.is_windows else "0",
        "{RTE_HAS_LIBFDT}": "1" if ctx.attr.has_libfdt else "0",
        "{RTE_HAS_LIBARCHIVE}": "1" if ctx.attr.has_libarchive else "0",
        "{RTE_HAS_LIBNUMA}": "1" if ctx.attr.has_libnuma else "0",
        "{RTE_HAS_JANSSON}": "1" if ctx.attr.has_jansson else "0",
        "{RTE_HAS_LIBPCAP}": "1" if ctx.attr.has_libpcap else "0",
        "{RTE_HAS_OPENSSL}": "0" if ctx.attr.has_openssl else "0",
        "{RTE_IOVA_IN_MBUF}": "1" if ctx.attr.enable_iova_as_pa else "0",
        "{RTE_MBUF_REFCNT_ATOMIC}": "1" if ctx.attr.mbuf_refcnt_atomic else "0",
        "{RTE_USE_C11_MEM_MODEL}": "1" if ctx.attr.use_c11_mem_model else "0",
        "{RTE_USE_LIBBSD}": "0",
        "{RTE_VER_YEAR}": ctx.attr.ver_year,
        "{RTE_VER_MONTH}": ctx.attr.ver_month,
        "{RTE_VER_MINOR}": ctx.attr.ver_minor,
        "{RTE_VER_SUFFIX}": ctx.attr.ver_suffix,
        "{RTE_CACHE_LINE_SIZE}": ctx.attr.cache_line_size if ctx.attr.cache_line_size else "64",
        "{RTE_VER_RELEASE}": ctx.attr.ver_release,
        "{RTE_HAS_CPUSET}": "1",
    }

    ctx.actions.expand_template(
        template = ctx.file.template,
        output = ctx.outputs.out,
        substitutions = substitutions,
        is_executable = False,
    )

generate_build_config = rule(
    implementation = _generate_build_config_impl,
    attrs = {
        "template": attr.label(mandatory = True, allow_single_file = True),
        "out": attr.output(mandatory = True),

        # System config
        "is_linux": attr.bool(default = True),
        "is_windows": attr.bool(default = False),

        # Architecture config
        "arch": attr.string(default = "x86_64"),
        "arch_64": attr.bool(default = True),
        "machine": attr.string(default = "corei7"),
        "compile_time_cpuflags": attr.string(default = "RTE_CPUFLAG_SSE,RTE_CPUFLAG_SSE2,RTE_CPUFLAG_SSE3,RTE_CPUFLAG_SSSE3,RTE_CPUFLAG_SSE4_1,RTE_CPUFLAG_SSE4_2,RTE_CPUFLAG_AES,RTE_CPUFLAG_AVX,RTE_CPUFLAG_AVX2,RTE_CPUFLAG_AVX512BW,RTE_CPUFLAG_AVX512CD,RTE_CPUFLAG_AVX512DQ,RTE_CPUFLAG_AVX512F,RTE_CPUFLAG_AVX512VL,RTE_CPUFLAG_PCLMULQDQ,RTE_CPUFLAG_RDRAND,RTE_CPUFLAG_RDSEED,RTE_CPUFLAG_VPCLMULQDQ"),

        # EAL config
        "max_ethports": attr.string(default = "32"),
        "pkt_mbuf_headroom": attr.string(default = "128"),
        "cache_line_size": attr.string(default = "64"),
        "use_hpet": attr.bool(default = False),
        "pmd_path": attr.string(default = "/usr/lib/dpdk"),

        # Feature flags
        "backtrace": attr.bool(default = True),
        "enable_stdatomic": attr.bool(default = True),
        "enable_trace_fp": attr.bool(default = False),
        "has_libfdt": attr.bool(default = False),
        "has_libarchive": attr.bool(default = False),
        "has_libnuma": attr.bool(default = False),
        "has_jansson": attr.bool(default = False),
        "has_libpcap": attr.bool(default = False),
        "has_openssl": attr.bool(default = False),
        "enable_iova_as_pa": attr.bool(default = True),
        "mbuf_refcnt_atomic": attr.bool(default = False),
        "use_c11_mem_model": attr.bool(default = False),
        "use_libbsd": attr.bool(default = False),

        # Version info
        "ver_year": attr.string(default = "23"),
        "ver_month": attr.string(default = "11"),
        "ver_minor": attr.string(default = "0"),
        "ver_suffix": attr.string(default = ""),
        "ver_release": attr.string(default = "99"),
    },
)
