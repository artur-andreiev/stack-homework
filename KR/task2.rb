class Catalog
  def initialize
    @products = [] # Інстансна змінна для зберігання списку товарів
  end

  # Метод для додавання нового товару
  def add_product(product)
    @products << product
    puts "#{product} додано до каталогу."
  end

  # Метод для перегляду всіх товарів
  def show_products
    puts "Список товарів:"
    @products.each { |product| puts "- #{product}" }
  end
end

# Приклад використання
catalog = Catalog.new
catalog.add_product("Ноутбук")
catalog.add_product("Смартфон")
catalog.show_products
