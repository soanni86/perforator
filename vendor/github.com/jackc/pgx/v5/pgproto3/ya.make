GO_LIBRARY()

LICENSE(MIT)

VERSION(v5.7.2)

SRCS(
    authentication_cleartext_password.go
    authentication_gss.go
    authentication_gss_continue.go
    authentication_md5_password.go
    authentication_ok.go
    authentication_sasl.go
    authentication_sasl_continue.go
    authentication_sasl_final.go
    backend.go
    backend_key_data.go
    big_endian.go
    bind.go
    bind_complete.go
    cancel_request.go
    chunkreader.go
    close.go
    close_complete.go
    command_complete.go
    copy_both_response.go
    copy_data.go
    copy_done.go
    copy_fail.go
    copy_in_response.go
    copy_out_response.go
    data_row.go
    describe.go
    doc.go
    empty_query_response.go
    error_response.go
    execute.go
    flush.go
    frontend.go
    function_call.go
    function_call_response.go
    gss_enc_request.go
    gss_response.go
    no_data.go
    notice_response.go
    notification_response.go
    parameter_description.go
    parameter_status.go
    parse.go
    parse_complete.go
    password_message.go
    pgproto3.go
    portal_suspended.go
    query.go
    ready_for_query.go
    row_description.go
    sasl_initial_response.go
    sasl_response.go
    ssl_request.go
    startup_message.go
    sync.go
    terminate.go
    trace.go
)

GO_TEST_SRCS(
    chunkreader_test.go
    function_call_test.go
    json_test.go
    pgproto3_private_test.go
)

GO_XTEST_SRCS(
    # backend_test.go
    bind_test.go
    copy_both_response_test.go
    # frontend_test.go
    fuzz_test.go
    query_test.go
    # trace_test.go
)

END()

RECURSE(
    example
    gotest
)
