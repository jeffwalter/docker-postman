require ["fileinto", "vacation", "variables"];
if header :contains "subject" "*****SPAM*****" {
    fileinto "Junk";
    stop;
}
if header :contains "x-spam-status" "yes" {
    fileinto "Junk";
    stop;
}
if header :matches "Subject" "*" {
        set "subject_was" "${1}";
}
vacation
  :days <SEND_EVERY_N_DAYS>
  :subject "Re: ${subject_was}"
  "<MESSAGE>";
