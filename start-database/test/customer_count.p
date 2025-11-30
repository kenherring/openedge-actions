message "getting customerCount...".
define variable customerCount as integer no-undo.
for each customer no-lock:
    customerCount = customerCount + 1.
end.
message "customerCount=" + string(customerCount).
