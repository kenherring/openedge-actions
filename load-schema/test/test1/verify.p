do transaction:
    create customer.
    customer.name = "NEW CUSTOMER".
    release customer.
end.

find first customer no-lock.
message "customer.name=" + customer.name.

message "SUCCESS!".
