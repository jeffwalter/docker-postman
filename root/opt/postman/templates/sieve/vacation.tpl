require ["date", "relational", "fileinto", "vacation", "variables"];
if header :contains "subject" "*****SPAM*****" {
    fileinto "Junk";
    stop;
}
if header :contains "x-spam-status" "yes" {
    fileinto "Junk";
    stop;
}
if allof(currentdate :value "ge" "date" "<YYY-MM-DD_START>",
         currentdate :value "le" "date" "<YYY-MM-DD_END>") {

    if header :matches "Subject" "*" {
            set "subject_was" "${1}";
    }
    vacation
        :days <SEND_EVERY_N_DAYS>
        :subject "Re: ${subject_was}"
  "<MESSAGE>"; }
