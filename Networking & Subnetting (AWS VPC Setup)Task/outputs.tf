output "vpc_id" {
  value = aws_vpc.gokul_vpc.id
}

output "public_subnets" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}

output "private_subnets" {
  value = [aws_subnet.private1.id, aws_subnet.private2.id]
}

output "nat_gateway_ip" {
  value = aws_eip.nat_eip.public_ip
}
