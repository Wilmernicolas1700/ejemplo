namespace :guardar do
    desc "se Guardó"
    task :put, [:email, :telefono, :nombre] do |t, args|

      email = args[:email]
      telefono = args[:telefono]
      nombre = args[:nombre]

    require 'aws-sdk-dynamodb'

    Aws.config.update({
      credentials: Aws::Credentials.new('4r1fte', 'lijc5'),
      region: 'localhost',
      
    })



person = Aws::DynamoDB::Client.new(endpoint: 'http://localhost:8000')
  item = {
    'email' => email,
    'telefono' => telefono,
    'nombre' => nombre
  }

  person.put_item({
      table_name: 'users',
      item: item
    
})
  end
end

