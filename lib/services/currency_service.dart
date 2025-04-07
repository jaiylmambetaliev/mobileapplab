

class CurrencyConverter {
  final double exchangeRate = 1.2; // Example static exchange rate

  double convertCurrency(double amount) {
    return amount * exchangeRate;
  }
}