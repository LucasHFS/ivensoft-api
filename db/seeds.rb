# frozen_string_literal: true

Model.destroy_all
Make.destroy_all
Category.destroy_all

organization = Organization.last

makes = {
  Volvo: ['FH 540', 'VM 270'],
  Volkswagen: ['MAN/9.170', 'MAN/9.160'],
  'Mercedes-Benz': ['ACCELO 1016'],
  Iveco: ['TECTOR 9-190', 'DAILY 70C17']
}

makes.each do |make_name, models|
  make = Make.create!(name: make_name, organization:)

  models.each do |model|
    make.models.create!(name: model, organization:)
  end
end

categories_names = ['Motor e Componentes',
                    'Sistema de Transmissão',
                    'Suspensão e Direção',
                    'Freios e Componentes de Freio',
                    'Sistema de Escape',
                    'Sistema Elétrico e Eletrônico',
                    'Sistema de Arrefecimento',
                    'Chassi e Estrutura',
                    'Carroceria e Componentes',
                    'Sistema de Combustível',
                    'Sistema de Admissão de Ar',
                    'Sistema de Lubrificação',
                    'Transmissão e Diferencial',
                    'Sistema de Ar Condicionado (se aplicável)',
                    'Pneus e Rodas',
                    'Sistema de Iluminação',
                    'Componentes de Segurança',
                    'Sistema de Emissão de Gases',
                    'Sistema de Controle de Emissões',
                    'Acessórios e Componentes Diverso']

Category.create!(categories_names.map { |name| { name:, organization: } })
