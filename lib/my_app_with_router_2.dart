

import 'package:angular/angular.dart';
import 'router.dart';

@Component(selector: 'my-app', template: '''
<router-page></router-page>

<my-dashboard-page [router]=""></my-dashboard-page>
<my-games-page ></my-games-page>

''')
class MyApp {

}

class MyDashboardPage implements RouterPage {

}