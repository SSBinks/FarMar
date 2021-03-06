
class FarMar::Sale
  attr_reader :id, :amount, :purch_time, :vend_id, :prod_id
  def initialize(id, amount, purch_time, vend, prod)
    @id = id
    @amount = amount
    @purch_time = purch_time
    @vend_id = vend
    @prod_id = prod
  end

  def self.all
    sales = {}
    discount = []
    CSV.open('support/sales.csv', 'r').each do |line|
      sales[line[0]] = line[1..4]
      id = line[0].to_i
      amount = line[1].to_i
      purch_time = line[2]
      vend = line[3].to_i
      prod = line[4].to_i
      discount << self.new(id, amount, purch_time, vend, prod)
    end
    return discount
  end

  def self.find(id)
    find_id = self.all
    find_id.each do |i|
      if i.id == id
        return i
      end
    end
  end

  def vendor
    FarMar::Vendor.find(@vend_id)
  end
  def product
    FarMar::Product.find(@prod_id)
  end

  def self.between(begin_time, end_time)
    times = []
    time = Time.now
    start = Chronic.parse(begin_time)
    fin = Chronic.parse(end_time)
    all.each do |i|
      time = Chronic.parse(i.purch_time)
      if start < time && time < fin
        times << i
      end
    end
  end
end
