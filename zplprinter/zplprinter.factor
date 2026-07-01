USING: http http.server http.server.dispatchers io io.servers
kernel namespaces zplprinter.client zplprinter.server
zplprinter.template ;
IN: zplprinter

: process-label-payload ( assoc -- response )
    label>zpl send-zpl-to-printer
    [ "Successfully sent to printer." print flush ] with-console
    respond-ok ;

: start-zpl-server ( -- )
    "Starting Webhook-Receiver on port 5000..." print flush
    output-stream get server-console set-global
    [ process-label-payload ] payload-handler set-global
    
    <dispatcher>
        webhook-action new "" add-responder
        test-form-action new "test" add-responder
    main-responder set-global
    
    5000 httpd wait-for-server ;

MAIN: start-zpl-server
