<div class="js-visible-on-cart-filled" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>

  {% set cart_button_classes = 'btn btn-primary btn-big btn-block mb-2' %}

  {# Cart page and popup CTA Module #}
  
  {% set cart_total = (settings.cart_minimum_value * 100) %}

  {% if cart_page %}
  
    {# Cart page CTA and minimum alert: Needs to be present or absence on DOM to work correctly with minimum price feature #}

    {% if cart.checkout_enabled %}
      <input id="go-to-checkout" class="{{ cart_button_classes }}" type="submit" name="go_to_checkout" value="{{ 'Iniciar compra' | translate }}"/>
    {% else %}

      {# Cart minium alert #}
      
      <div class="alert alert-warning w-100 mb-2 text-center">
        {{ "El monto mínimo de compra es de {1} sin incluir el costo de envío" | t(cart_total | money) }}
      </div>
    {% endif %}
  {% else %}

    {# Cart popup CTA and minimum alert #}

    <div class="js-ajax-cart-submit" {{ not cart.checkout_enabled ? 'style="display:none"' }} id="ajax-cart-submit-div" >
      <input class="{{ cart_button_classes }}" type="submit" name="go_to_checkout" value="{{ 'Iniciar compra' | translate }}" data-component="cart.checkout-button"/>
    </div>
    <div class="js-ajax-cart-minimum alert alert-warning mb-2 text-center" {{ cart.checkout_enabled ? 'style="display:none"' }} id="ajax-cart-minumum-div">
      {{ "El monto mínimo de compra es de {1} sin incluir el costo de envío" | t(cart_total | money) }}
    </div>

    <input type="hidden" id="ajax-cart-minimum-value" value="{{ cart_total }}"/>
  {% endif %}

  {# Cart panel continue buying link #}

  <div class="text-center">
    <a href="{% if cart_page %}{{ store.products_url }}{% else %}#{% endif %}" {% if not cart_page %}data-target="#modal-cart"{% endif %} class="{% if not cart_page %}js-modal-close-private{% endif %} btn btn-link">{{ 'Ver más productos' | translate }}</a>
  </div>
</div>