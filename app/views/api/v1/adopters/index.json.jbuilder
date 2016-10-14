json.adopters @adopters do |adopter|
  json.partial! 'api/v1/adopters/adopter', adopter: adopter
end
json.total_pages @adopters.total_pages
