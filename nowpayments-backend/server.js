// server.js
const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
app.use(cors());
app.use(express.json());

// Replace this with your actual NOWPayments API key
const API_KEY = "";

app.post("/create-invoice", async (req, res) => {
  try {
    const { price, currency } = req.body;

    // Call NOWPayments API to create invoice
    const response = await axios.post(
      "https://api.nowpayments.io/v1/invoice",
      {
        price_amount: price, // e.g. 25.0
        price_currency: currency, // e.g. "USD"
        pay_currency: "btc", // crypto you want to receive
        order_id: `order_${Date.now()}`, // unique order id, here timestamp
        order_description: "Pro Package Payment",
        ipn_callback_url: "https://yourdomain.com/ipn", // Optional: your IPN URL
      },
      {
        headers: { "x-api-key": API_KEY },
      }
    );

    res.json({ url: response.data.invoice_url });
  } catch (error) {
    res.status(500).json({ error: error.message || "Server error" });
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
