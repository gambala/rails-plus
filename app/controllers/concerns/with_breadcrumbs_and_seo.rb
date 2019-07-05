module WithBreadcrumbsAndSeo
  extend ActiveSupport::Concern

  included do
    def h1_from_breadcrumbs
      breadcrumbs[-1][:label]
    end

    def title_from_breadcrumbs
      breadcrumbs[1..-1].reverse.map { |b| b[:label] }.join(' - ')
    end

    def site_title
      t('site.title')
    end

    def set_seo_tags_with_breadcrumbs(force: false)
      return if breadcrumbs.empty?
      return if breadcrumbs.size == 1 && force == false
      h1 h1_from_breadcrumbs || site_title
      title [title_from_breadcrumbs, site_title].compact.join(' | ')
    end
  end
end
