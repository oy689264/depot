class Product < ApplicationRecord

    has_many :line_items

    before_destroy :ensure_not_referenced_by_any_line_item

    validates :title, :description, :image_url, presence: true  # 约束字段不能为空
    validates :price, numericality: {greater_than_or_equal_to: 0.01}  # 约束价格大于或等于0.01
    validates :title, uniqueness: true  # 唯一的  标题
    validates :image_url, allow_blank: true, format: {
        with:   %r{\.(gifjpg|png)\Z}i,
        message: '不是图片类型'
    }  # 允许为空防止，图片为空时候产生多条错误信息。正则匹配图片类型。
    private

    def ensure_not_referenced_by_any_line_item
        unless line_items.empty?
            errors.add(:base, '存在订单项')
            throw :abort
        end
    end
end
