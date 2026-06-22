USING: calendar io namespaces tools.test zplprinter.server ;

IN: zplprinter.tests.server

! Server-Konsole für die Responder-Tests initialisieren, um Abstürze zu vermeiden
output-stream get server-console set-global

! === Server ===

[ t ] [ current-utc-timestamp length 10 > ] unit-test
[ 200 ] [ respond-ok code>> ] unit-test
[ 400 ] [ "Test error" respond-bad code>> ] unit-test

ABOUT: "zplprinter.tests.server"