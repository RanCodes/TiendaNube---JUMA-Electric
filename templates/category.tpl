{% set has_filters_available = products and has_filters_enabled and (filter_categories is not empty or product_filters is not empty) %}

{# Only remove this if you want to take away the theme onboarding advices #}
{% set show_help = not has_products %}

{% if settings.pagination == 'infinite' %}
	{% paginate by 12 %}
{% else %}
	{% paginate by 60 %}
{% endif %}

{% set columns_mobile = settings.grid_columns_mobile %}
{% set columns_desktop = settings.grid_columns_desktop %}

{% set grid_mobile_class = 
	columns_mobile == 2 ? 'grid-2' :
	columns_mobile == 1 ? 'grid-1'
%}

{% set grid_desktop_class = 
	columns_desktop == 6 ? 'grid-md-6' : 
	columns_desktop == 5 ? 'grid-md-5' : 
	columns_desktop == 4 ? 'grid-md-4'
%}

{% set sort_text = {
	'user': 'our_components.sort_by.options.custom' | tt,
	'price-ascending': 'our_components.sort_by.options.price_ascending' | tt,
	'price-descending': 'our_components.sort_by.options.price_descending' | tt,
	'alpha-ascending': 'our_components.sort_by.options.alpha_ascending' | tt,
	'alpha-descending': 'our_components.sort_by.options.alpha_descending' | tt,
	'created-ascending': 'our_components.sort_by.options.created_ascending' | tt,
	'created-descending': 'our_components.sort_by.options.created_descending' | tt,
	'best-selling': 'our_components.sort_by.options.best_selling' | tt,
} %}

{% set category_banner = (category.images is not empty) or ("banner-products.jpg" | has_custom_image) %}

{% if not show_help %}
	<section class="category-body" data-store="category-grid-{{ category.id }}">
		<div class="container py-4">
			{% if category_banner %}
				{% include 'snipplets/category-banner.tpl' %}
			{% endif %}
			<div class="grid grid-md-auto mb-md-4 align-items-end">
				<div class="mb-1">
					{% snipplet "breadcrumbs.tpl" %}
					<div class="grid grid-1-auto align-items-end">
						<h1 class="h4 mb-0">{{ category.name }}</h1>
						{% if products | length > 1 %}
							<div class="d-md-none text-right font-small mb-1">
								{{ products_count }} {{ 'productos' | translate }}
							</div>
						{% endif %}
					</div>
					{% if category.description %}
						<p class="font-small mt-1 mb-0">{{ category.description }}</p>
					{% endif %}
				</div>
				{% if products %}
					<div class="d-none d-md-block">
						{{ component(
							'sort-by',{
								sort_by_classes: {
									container: 'mb-1',
									select_group: "d-inline-block w-auto mb-0",
									select_label: "font-small d-block mb-1",
									select: "form-select-small",
									select_svg: "icon-inline icon-xs icon-w-14 svg-icon-text",
								},
								select_svg_id: 'chevron-down'
							}) 
						}}
					</div>
				{% endif %}
			</div>
			{% if products %}
                                <div class="js-category-controls category-controls d-md-none grid{% if products and has_filters_available %} grid-no-gap grid-2{% endif %} px-3 my-3 top-line bottom-line">
					{% if has_filters_available %}
						<button class="js-modal-open-private py-2 right-line" data-target="#modal-filters" data-component="filter-button">
							<svg class="icon-inline svg-icon-text mr-2"><use xlink:href="#filter"/></svg>
							<span class="d-inline-block my-1">{{ 'Filtrar' | t }}</span>
						</button>
					{% endif %}
					<button class="js-modal-open-private py-2 grid grid-auto grid-no-gap align-items-center justify-content-center" data-target="#modal-sort-by">
						<svg class="icon-inline svg-icon-text mr-2"><use xlink:href="#sort-by"/></svg>
						<div class="text-left ml-1">
							<span class="d-inline-block my-1">{{ 'Ordenar por' | t }}:</span>
							{% for sort_method in sort_methods %}
								{% if sort_by == sort_method %}
									<div class="font-smallest font-weight-bold">
										{{ sort_text[sort_method] | t }}
									</div>
								{% endif %}
							{% endfor %}
						</div>
					</button>
				</div>
				<div class="js-category-controls-prev category-controls-sticky-detector"></div>

				{% if has_filters_available %}
					{{ component(
						'modal',{
							modal_id: 'modal-filters',
							data_component: 'modal-filters',
							position: {
								appear_from: 'left',
							},
							layout: {
								width_desktop: 'large',
							},
							content: {
								title: 'Filtrar por' | t,
								body: component(
								'filters/filters',{
									accordion: true,
									parent_category_link: false,
									applied_filters_badge: true,
									container_classes: {
										filters_container: "visible-when-content-ready",
									},
									accordion_classes: {
										title_container: "accordion-toggle align-items-center",
										title_col: "my-1 pr-3 d-flex align-items-center",
										title: "mb-0",
										actions_col: "my-1",
										title_icon: "icon-inline svg-icon-text"
									},
									filter_classes: {
										list: "list-unstyled my-3",
										list_item: "mb-2",
										list_link: "font-small",
										badge: "h1 ml-1",
										show_more_link: "d-inline-block btn-link font-small mt-1",
										checkbox_last: "m-0",
										price_group: 'price-filter-container filter-accordion',
										price_title: 'mb-3',
										price_submit: 'btn btn-inline price-filter-btn',
										applying_feedback_message: 'font-big mr-2',
										applying_feedback_icon: 'icon-inline font-big icon-spin svg-icon-text'
									},
									accordion_show_svg_id: 'chevron',
									accordion_hide_svg_id: 'chevron-down',
									applying_feedback_svg_id: 'spinner-third'
								}),
							},
							icons: {
								back_icon_id: 'chevron',
								close_icon_id: 'times',
							},
							modal_classes: {
								body: 'p-0',
								close_icon: 'icon-inline icon-2x',
							}
						}) 
					}}

				{% endif %}

				{{ component(
					'modal',{
						modal_id: 'modal-sort-by',
						data_component: 'modal-sort-by',
						position: {
							appear_from: 'bottom',
						},
						layout: {
							width_desktop: 'large',
						},
						content: {
							title: 'Ordenar por' | t,
							body: component(
							'sort-by',{
								list: true,
								sort_by_classes: {
									list_title: 'd-none',
									list: 'radio-button-container list-unstyled mb-3',
									list_item: 'radio-button-item',
									radio_button: "radio-button",
									radio_button_content: "radio-button-content",
									radio_button_icons_container: "radio-button-icons-container",
									radio_button_icon: "radio-button-icon",
									radio_button_label: "radio-button-label",
									applying_feedback_message: 'font-big mr-2',
									applying_feedback_icon: 'icon-inline font-big icon-spin svg-icon-text',
								},
								applying_feedback_svg_id: 'spinner-third',
							}),
						},
						icons: {
							back_icon_id: 'chevron',
							close_icon_id: 'times',
						},
						modal_classes: {
							modal: 'h-auto',
							close_icon: 'icon-inline icon-2x',
						}
					}) 
				}}
			{% endif %}
			<div class="grid{% if products and has_filters_available %} grid-md-auto-4{% endif %}">
				{% if products and has_filters_available %}
					<div class="visible-when-content-ready">
						{% if has_applied_filters %}
							{{ component(
								'filters/remove-filters',{
									container_classes: {
										filters_container: "mb-md-4 pb-md-2",
									},
									filter_classes: {
										applied_filters_label: "h6 font-weight-bold mb-2 d-none d-md-block ",
										remove: "chip",
										remove_icon: "chip-remove-icon",
										remove_all: "btn-link d-inline-block mt-1 mt-md-0 font-small",
									},
									remove_filter_svg_id: 'times',
								}) 
							}}
						{% else %}
							<h2 class="h6 mb-4 d-none d-md-block ">{{ 'Filtrar por' | t }}</h2>
						{% endif %}
						<div class="d-none d-md-block ">
							{{ component(
								'filters/filters',{
									container_classes: {
										filters_container: "visible-when-content-ready",
									},
									filter_classes: {
										parent_category_link: "d-block",
										parent_category_link_icon: "icon-inline icon-flip-horizontal mr-2 svg-icon-text",
										list: "mb-4 pb-4 list-unstyled bottom-line",
										list_item: "mb-2",
										list_link: "font-small",
										list_title: "font-small font-family-body text-uppercase mb-3",
										show_more_link: "d-inline-block btn-link font-small mt-1",
										checkbox_last: "m-0",
										price_group: 'price-filter-container filter-accordion mb-4 pb-2',
										price_title: 'font-weight-bold mb-4 font-body',
										price_submit: 'btn btn-default d-inline-block',
										price_group: 'price-filter-container mb-4 pb-2',
										price_title: 'font-small font-family-body text-uppercase mb-3',
										price_submit: 'btn btn-inline price-filter-btn svg-icon-mask'
									},
								}) 
							}}
						</div>
					</div>
				{% endif %}
                                <div data-store="category-grid-{{ category.id }}" class="overflow-none">
                                        {% if products %}
                                                <div class="js-product-table w-100 grid {{ grid_mobile_class }} {{ grid_desktop_class }}">
							{% include 'snipplets/product_grid.tpl' %}
						</div>
						{% if settings.pagination == 'infinite' %}
							{% set pagination_type_val = true %}
						{% else %}
							{% set pagination_type_val = false %}
						{% endif %}

						{% include "snipplets/grid/pagination.tpl" with {infinite_scroll: pagination_type_val} %}
					{% else %}
						<div class="font-big py-5 text-center" data-component="filter.message">
							{{(has_filters_enabled ? "No tenemos resultados para tu búsqueda. Por favor, intentá con otros filtros." : "Próximamente") | translate}}
						</div>
					{% endif %}
				</div>
		</div>
	</section>
{% elseif show_help %}
	{# Category placeholder #}
	{% include 'snipplets/defaults/show_help_category.tpl' %}
{% endif %}
