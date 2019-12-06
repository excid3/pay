module Pay
  module Stripe

    module Charge
      extend ActiveSupport::Concern

      def stripe?
        processor == "stripe"
      end

      # Doesn't work in jumpstartpro
      # #######
      # Team.first.charges.first.stripe_charge
      # > NoMethodError: undefined method `retrieve' for Pay::Stripe::Charge:Module
      def stripe_charge
        Stripe::Charge.retrieve(processor_id)
      rescue ::Stripe::StripeError => e
        raise Error, e.message
      end

      # To capture a Charge created through a PaymentIntent we have to capture the PaymentIntent itself.
      # #######
      # Stripe::Charge.retrieve(processor_id).capture
      # > Stripe::InvalidRequestError: This uncaptured Charge was created by a PaymentIntent. You must capture the PaymentIntent instead.
      def stripe_capture
        Pay::Payment.from_id(payment_intent).capture
        update(captured: true)

      rescue ::Stripe::StripeError => e
        raise Error, e.message
      end

      def stripe_refund!(amount_to_refund)
        Stripe::Refund.create(
          charge: processor_id,
          amount: amount_to_refund
        )

        update(amount_refunded: amount_to_refund)
      rescue ::Stripe::StripeError => e
        raise Error, e.message
      end
    end

  end
end
