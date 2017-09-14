require ["fileinto"];
if header :contains "subject" "*****SPAM*****"
{
	fileinto "Junk";
}
if header :contains "x-spam-status" "yes"
{
	fileinto "Junk";
}
