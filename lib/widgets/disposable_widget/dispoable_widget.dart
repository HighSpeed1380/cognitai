import 'dart:async';

class DisposableWidget {
  List<StreamSubscription> subscriptions = [];

  void cancelSubscriptions() {
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
  }

  void addSubscription(StreamSubscription subscription) {
    subscriptions.add(subscription);
  }
}

extension DisposableStreamSubscriton on StreamSubscription {
  void canceledBy(DisposableWidget widget) {
    widget.addSubscription(this);
  }
}
