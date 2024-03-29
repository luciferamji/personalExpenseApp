import 'package:flutter/material.dart';
import 'package:personal_expense/models/Transaction.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/widgets/transactions/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);
  List<Map<String, Object>> get groupedTranValue {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      
      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    }).reversed.toList();
  }

  double get total {
    return groupedTranValue.fold(0.0, (sum, item) => sum + item["amount"]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTranValue.map((data) {
            return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(data["day"], data["amount"],
                    total == 0.0 ? 0.0 : (data["amount"] as double) / total));
          }).toList(),
        ),
      ),
    );
  }
} 
