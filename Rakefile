# Rakefile for pdftk and pdfocr docker images

task :default => [ './pdftk/.done' ]

desc 'Build pdftk'
file './pdftk/.done' => './pdftk/Dockerfile' do
  touch './pdftk/.done'
end

