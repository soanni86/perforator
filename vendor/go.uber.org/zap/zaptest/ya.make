GO_LIBRARY()

LICENSE(MIT)

VERSION(v1.27.0)

SRCS(
    doc.go
    logger.go
    testingt.go
    timeout.go
    writer.go
)

GO_TEST_SRCS(
    logger_test.go
    testingt_test.go
    timeout_test.go
    writer_test.go
)

END()

RECURSE(
    gotest
    observer
)
