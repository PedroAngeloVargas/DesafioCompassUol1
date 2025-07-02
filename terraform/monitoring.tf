/* Monitoramento com Cloudwatch e notificação com SNS para verificar o uso de CPU*/


#Descrição do Alerta
resource "aws_sns_topic" "alerta" {
  name = "ALERTA-USO-DE-CPU-ESTA-ALEM-DO-PERMITIDO"
}

#Aplicação para o envio do Alerta
resource "aws_sns_topic_subscription" "envio" {
  topic_arn = aws_sns_topic.alerta.arn
  protocol = "email"
  endpoint = "SEU_EMAIL" #Adicione seu email para receber alertas da aws
}

#CloudWatch para monitorar o uso de Cpu da VM
resource "aws_cloudwatch_metric_alarm" "monitor" {
  alarm_name                = "Controle de Uso de CPU"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = "Monitoramento de Uso de CPU"
  insufficient_data_actions = []

  dimensions = {
    InstanceId = aws_instance.vm.id
  }

  alarm_actions = [ aws_sns_topic.alerta.arn ]
}
