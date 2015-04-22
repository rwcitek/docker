# Rakefile for pdftk and pdfocr docker images

task :default => [ './pdftk/.done', './pdfocr/.done' ]

desc 'Build pdftk'
file './pdftk/.done' => './pdftk/Dockerfile' do
  sh 'cd ./pdftk; sudo docker build -t "edhowland/pdftk:v0.1" .'
  touch './pdftk/.done'
end

desc 'Build pdfocr'
file './pdfocr/.done' => './pdfocr/Dockerfile' do
  sh 'cd pdfocr; sudo docker build -t "edhowland/pdfocr:v0.1" .'
  touch './pdfocr/.done'
end

task :clean do
  rm_f './pdftk/.done'
  rm_f './pdfocr/.done'
end
