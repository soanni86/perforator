GO_LIBRARY()

LICENSE(Apache-2.0)

VERSION(v2.18.0)

SRCS(
    utils.go
)

END()

RECURSE(
    issues
    std
    stress
)
