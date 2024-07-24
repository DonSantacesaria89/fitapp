import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Fit',
                    style: TextStyle(
                      color: Color.fromARGB(229, 229, 160, 0),
                      fontSize: 100,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Arial',
                    ),
                  ),
                  TextSpan(
                    text: 'App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 100,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Arial',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Gestisci il tuo \nbenessere',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromARGB(229, 229, 160, 0),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondPage()),
                  );
                },
                child: const Text(
                  'Inizia',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SecondPage({super.key});

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReservedAreaPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Utente non trovato. Controlla l\'email inserita.';
          break;
        case 'wrong-password':
          errorMessage = 'Password errata. Riprova.';
          break;
        default:
          errorMessage = 'Si è verificato un errore.\nControlla le credenziali inserite.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: '\n\nBenvenuto in\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w100,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Arial',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Fit',
                      style: TextStyle(
                        color: Color.fromARGB(229, 229, 160, 0),
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text: 'App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    'Password dimenticata?',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(229, 229, 160, 0),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () => _login(context),
                child: const Text(
                  'Entra',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Non hai un account? ',
                    style: const TextStyle(color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Registrati',
                        style: const TextStyle(
                          color: Colors.orange,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegistrationPage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _userType = 'Atleta';

  Future<void> _register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text,
        'surname': _surnameController.text,
        'email': _emailController.text,
        'userType': _userType,
      });

      // Show success message and navigate back to login page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrazione avvenuta con successo!'),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'L\'email è già in uso. Prova con un\'altra email.';
          break;
        case 'invalid-email':
          errorMessage = 'L\'email inserita non è valida. Controlla e riprova.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Operazione non consentita. Contatta il supporto.';
          break;
        case 'weak-password':
          errorMessage = 'La password è troppo debole. Usane una più sicura.';
          break;
        default:
          errorMessage = 'Errore sconosciuto. Riprova più tardi.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Entra in ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontStyle: FontStyle.italic),
              ),
              TextSpan(
                text: 'Fit',
                style: TextStyle(
                  color: Color.fromARGB(229, 229, 160, 0),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(
                text: 'App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Gestisci il tuo benessere',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.italic
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cognome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: const Text('Coach', style: TextStyle(color: Colors.white)),
                    leading: Radio(
                      value: 'Coach',
                      groupValue: _userType,
                      onChanged: (value) {
                        setState(() {
                          _userType = value.toString();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Atleta', style: TextStyle(color: Colors.white)),
                    leading: Radio(
                      value: 'Atleta',
                      groupValue: _userType,
                      onChanged: (value) {
                        setState(() {
                          _userType = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(229, 229, 160, 0),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _register,
              child: const Text(
                'Registrati',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReservedAreaPage extends StatefulWidget {
  const ReservedAreaPage({super.key});

  @override
  _ReservedAreaPageState createState() => _ReservedAreaPageState();
}

class _ReservedAreaPageState extends State<ReservedAreaPage> {
  String userName = '';
  String userId = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userName = userDoc['name'] ?? '';
        userId = user.uid;
        userEmail = user.email ?? '';
        _createSampleScheduleForUser();  // Assicurati che venga chiamato qui dopo aver ottenuto l'ID utente
      });
    }
  }

  Future<void> _createSampleScheduleForUser() async {
    if (userId.isNotEmpty) {
      List<Map<String, dynamic>> sessions = [
        {
          'sessionTitle': 'Sessione 1',
          'exercises': [
            {'exerciseName': 'Push Up', 'series': 3, 'repetitions': 10},
            {'exerciseName': 'Pull Up', 'series': 3, 'repetitions': 8},
          ],
        },
        {
          'sessionTitle': 'Sessione 2',
          'exercises': [
            {'exerciseName': 'Squat', 'series': 4, 'repetitions': 12},
            {'exerciseName': 'Deadlift', 'series': 4, 'repetitions': 10},
          ],
        },
        {
          'sessionTitle': 'Sessione 3',
          'exercises': [
            {'exerciseName': 'Bench Press', 'series': 3, 'repetitions': 10},
            {'exerciseName': 'Shoulder Press', 'series': 3, 'repetitions': 8},
          ],
        },
      ];

      try {
        await addSchedule('Massimo Peso', userEmail, 'Bodybuilding Firestore', sessions);
        print('Scheda creata con successo!');
      } catch (e) {
        print('Errore durante la creazione della scheda: $e');
      }
    }
  }

  Future<void> addSchedule(String creatorEmail, String userEmail, String title, List<Map<String, dynamic>> sessions) async {
  CollectionReference schedules = FirebaseFirestore.instance.collection('schedules');

  // Controlla se esiste già una scheda con lo stesso titolo
  QuerySnapshot existingSchedules = await schedules
      .where('title', isEqualTo: title)
      .where('user', isEqualTo: userEmail)
      .get();

  if (existingSchedules.docs.isEmpty) {
    // Aggiungi una nuova scheda se non esiste già
    DocumentReference scheduleRef = await schedules.add({
      'creator': creatorEmail,
      'user': userEmail,
      'title': title,
      'creationDate': Timestamp.now(),
      'sessions_num': 3,
    });

    // Aggiungi sedute alla scheda
    for (var session in sessions) {
      DocumentReference sessionRef = await scheduleRef.collection('sessions').add({
        'sessionTitle': session['sessionTitle'],
      });

      // Aggiungi esercizi alla seduta
      for (var exercise in session['exercises']) {
        await sessionRef.collection('exercises').add({
          'exerciseName': exercise['exerciseName'],
          'series': exercise['series'],
          'repetitions': exercise['repetitions'],
        });
      }
    }
  } else {
    print('Una scheda con lo stesso titolo esiste già.');
  }
}


  void _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // For alignment
                  IconButton(
                    icon: const Icon(Icons.logout, color: Color.fromARGB(229, 229, 160, 0)),
                    onPressed: _logout,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Ciao, $userName!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Fit',
                      style: TextStyle(
                        color: Color.fromARGB(229, 229, 160, 0),
                        fontSize: 80,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Arial',
                      ),
                    ),
                    TextSpan(
                      text: 'App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildMenuItem(
                context,
                'I tuoi coach',
                Icons.person,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnderConstructionPage()),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'I tuoi centri sportivi',
                Icons.location_city,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnderConstructionPage()),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'Le tue schede',
                Icons.description,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySchedulesPage()),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'I tuoi obiettivi',
                Icons.fitness_center,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnderConstructionPage()),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'Il tuo profilo',
                Icons.person_outline,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnderConstructionPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          onTap: onTap,
        ),
        Container(
          height: 1,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ],
    );
  }
}

class MySchedulesPage extends StatelessWidget {
  final PageController _pageController = PageController();

  MySchedulesPage({super.key});

  Future<List<DocumentSnapshot>> _fetchSchedules(String userEmail) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .where('user', isEqualTo: userEmail)
        .get();

    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Le tue ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(
                text: 'Schede',
                style: TextStyle(
                  color: Color.fromARGB(229, 229, 160, 0),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchSchedules(userEmail),
        builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nessuna scheda trovata.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Le schede dei Coach',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(229, 229, 160, 0),
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: PageView(
                      controller: _pageController,
                      children: snapshot.data!
                          .map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return _buildCoachCard(
                          context,
                          data['title'] ?? 'Titolo non disponibile',
                          'di ${data['creator'] ?? 'Creatore sconosciuto'}',
                          (data['creationDate'] as Timestamp).toDate().toLocal().toString().split(' ')[0] ?? 'Data non disponibile',
                          '${data['sessions_num'] ?? 0} sedute',
                          document.id,  // Pass the document ID
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: snapshot.data!.length,
                      effect: const WormEffect(
                        dotHeight: 12,
                        dotWidth: 12,
                        dotColor: Colors.grey,
                        activeDotColor: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Le schede fatte da Te',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(229, 229, 160, 0),
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(229, 229, 160, 0),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UnderConstructionPage()),
                      );
                    },
                    child: const Text(
                      'Crea una scheda',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoachCard(BuildContext context, String title, String coach, String date, String sessions, String scheduleId) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleDetailPage(scheduleId: scheduleId),
          ),
        );
      },
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromARGB(229, 229, 160, 0),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                coach,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                sessions,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.remove_red_eye,
                  color: Colors.orange,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleDetailPage extends StatelessWidget {
  final String scheduleId;

  const ScheduleDetailPage({super.key, required this.scheduleId});

  Future<Map<String, dynamic>> _fetchScheduleDetails() async {
    DocumentSnapshot scheduleDoc = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleId)
        .get();
    
    Map<String, dynamic> scheduleData = scheduleDoc.data() as Map<String, dynamic>;

    QuerySnapshot sessionsSnapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleId)
        .collection('sessions')
        .get();

    List<Map<String, dynamic>> sessions = sessionsSnapshot.docs.map((doc) {
      Map<String, dynamic> sessionData = doc.data() as Map<String, dynamic>;
      sessionData['sessionId'] = doc.id;
      sessionData['scheduleId'] = scheduleId;  // Aggiungi l'ID della scheda alla sessione
      return sessionData;
    }).toList();

    scheduleData['sessions'] = sessions;
    return scheduleData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Dettaglio ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(
                text: 'Scheda',
                style: TextStyle(
                  color: Color.fromARGB(229, 229, 160, 0),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchScheduleDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Nessun dettaglio disponibile', style: TextStyle(color: Colors.white)));
          }

          Map<String, dynamic> scheduleData = snapshot.data!;
          List<Map<String, dynamic>> sessions = scheduleData['sessions'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    scheduleData['title'],
                    style: const TextStyle(
                      color: Color.fromARGB(229, 229, 160, 0),
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> session = sessions[index];
                      return SessionCard(session: session);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final Map<String, dynamic> session;

  const SessionCard({super.key, required this.session});

  Future<List<Map<String, dynamic>>> _fetchExercises() async {
    QuerySnapshot exercisesSnapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(session['scheduleId'])
        .collection('sessions')
        .doc(session['sessionId'])
        .collection('exercises')
        .get();

    return exercisesSnapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();
  }

@override
Widget build(BuildContext context) {
  return Card(
    color: Colors.grey[850],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session['sessionTitle'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w200,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Serie',
                style: TextStyle(
                  color: Color.fromARGB(229, 229, 160, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Reps',
                style: TextStyle(
                  color: Color.fromARGB(229, 229, 160, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Text('Nessun esercizio disponibile', style: TextStyle(color: Colors.white));
              }

              List<Map<String, dynamic>> exercises = snapshot.data!;

              return Column(
                children: exercises.map((exercise) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UnderConstructionPage()),
                      );
                    },
                    child: Card(
                      color: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                exercise['exerciseName'],
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,),
                              ),
                            ),
                            const Icon(
                              Icons.remove_red_eye,
                              color: Color.fromARGB(229, 229, 160, 0),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 30, // larghezza fissa per garantire allineamento
                              child: Text(
                                '${exercise['series']}',
                                style: const TextStyle(color: Colors.white, fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,),
                                textAlign: TextAlign.center, // per centrare il testo
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 30, // larghezza fissa per garantire allineamento
                              child: Text(
                                '${exercise['repetitions']}',
                                style: const TextStyle(color: Colors.white, fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,),
                                textAlign: TextAlign.center, // per centrare il testo
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    ),
  );
}

}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendPassword(BuildContext context) async {
    String email = _emailController.text;

    try {
      // Verifica se l'email è presente nel database
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // Invia email di reset password tramite Firebase Authentication
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email inviata con successo! Controlla la tua casella di posta.'),
          ),
        );
        Navigator.pop(context);
      } else {
        throw FirebaseAuthException(code: 'user-not-found');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Utente non trovato. Controlla l\'email inserita.';
          break;
        default:
          errorMessage = 'Si è verificato un errore. Riprova più tardi.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Recupera ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(
                text: 'Password',
                style: TextStyle(
                  color: Color.fromARGB(229, 229, 160, 0),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Inserisci la tua email per recuperare la password',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w100, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(229, 229, 160, 0),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () => _sendPassword(context),
              child: const Text(
                'Invia',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnderConstructionPage extends StatelessWidget {
  const UnderConstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Lavori in ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(
                text: 'Corso',
                style: TextStyle(
                  color: Color.fromARGB(229, 229, 160, 0),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Icon(
              Icons.build,
              color: Color.fromARGB(229, 229, 160, 0),
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Questa funzionalità è ancora in fase di sviluppo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Al momento puoi registrarti, autenticarti e visualizzare le schede preparate dai coach.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(229, 229, 160, 0),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Torna Indietro',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
