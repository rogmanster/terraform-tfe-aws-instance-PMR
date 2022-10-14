#Instance
variable "instance_count" {
  description = "The number of EC2 Instances"
  default = 1
}
variable "instance_type" {
  description = "The type of EC2 Instances"
  default = "t2.micro"
}
variable "name" {
  description = "The name of EC2 Instances"
  default = "rchao"
}
variable "ttl" {
  description = "A TTL for when to terminate"
  default = "1"
}
