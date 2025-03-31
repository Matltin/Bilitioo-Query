-- Insert 32 Iranian cities (one from each province)
INSERT INTO "city" ("province", "county") VALUES
  -- Region 1: Tehran and surrounding provinces
  ('Tehran', 'Tehran'),
  ('Alborz', 'Karaj'),
  ('Qazvin', 'Qazvin'),
  ('Qom', 'Qom'),
  ('Markazi', 'Arak'),
  ('Semnan', 'Semnan'),
  
  -- Region 2: Northern provinces
  ('Mazandaran', 'Sari'),
  ('Gilan', 'Rasht'),
  ('Golestan', 'Gorgan'),
  ('Ardabil', 'Ardabil'),
  
  -- Region 3: Northwestern provinces
  ('East Azerbaijan', 'Tabriz'),
  ('West Azerbaijan', 'Urmia'),
  ('Zanjan', 'Zanjan'),
  ('Kurdistan', 'Sanandaj'),
  
  -- Region 4: Western provinces
  ('Kermanshah', 'Kermanshah'),
  ('Ilam', 'Ilam'),
  ('Hamadan', 'Hamadan'),
  ('Lorestan', 'Khorramabad'),
  
  -- Region 5: Southwestern provinces
  ('Khuzestan', 'Ahvaz'),
  ('Chaharmahal and Bakhtiari', 'Shahrekord'),
  ('Kohgiluyeh and Boyer-Ahmad', 'Yasuj'),
  
  -- Region 6: Central and Eastern provinces
  ('Isfahan', 'Isfahan'),
  ('Yazd', 'Yazd'),
  ('Fars', 'Shiraz'),
  ('Bushehr', 'Bushehr'),
  
  -- Region 7: Southeastern provinces
  ('Kerman', 'Kerman'),
  ('Hormozgan', 'Bandar Abbas'),
  ('Sistan and Baluchestan', 'Zahedan'),
  
  -- Region 8: Northeastern provinces
  ('North Khorasan', 'Bojnord'),
  ('Razavi Khorasan', 'Mashhad'),
  ('South Khorasan', 'Birjand'),
  ('Kerman', 'Jiroft');

-- Insert terminals for each city
INSERT INTO "terminal" ("name", "address") VALUES
  -- Tehran terminals
  ('Tehran South Bus Terminal', 'Terminal-e Jonoub, Shoosh Square, Tehran'),
  ('Tehran West Bus Terminal', 'Terminal-e Gharb, Azadi St., Tehran'),
  ('Tehran East Bus Terminal', 'Terminal-e Shargh, Damavand St., Tehran'),
  ('Tehran Beihaghi Bus Terminal', 'Argentina Square, Tehran'),
  ('Tehran Railway Station', 'Railway Square, Jomhouri St., Tehran'),
  ('Mehrabad International Airport', 'Azadi St., Tehran'),
  ('Imam Khomeini International Airport', 'Tehran-Qom Highway, Tehran'),
  
  -- Karaj terminals
  ('Karaj Central Bus Terminal', 'Azimieh District, Karaj'),
  ('Karaj Railway Station', 'Railway Square, Karaj'),
  
  -- Qazvin terminals
  ('Qazvin Bus Terminal', 'Terminal Blvd, Qazvin'),
  ('Qazvin Railway Station', 'Railway Square, Qazvin'),
  
  -- Qom terminals
  ('Qom Bus Terminal', 'Terminal St., Qom'),
  ('Qom Railway Station', 'Railway Square, Qom'),
  
  -- Arak terminals
  ('Arak Bus Terminal', 'Terminal St., Arak'),
  ('Arak Railway Station', 'Railway Square, Arak'),
  ('Arak Airport', 'Airport Road, Arak'),
  
  -- Semnan terminals
  ('Semnan Bus Terminal', 'Terminal St., Semnan'),
  ('Semnan Railway Station', 'Railway Square, Semnan'),
  
  -- Sari terminals
  ('Sari Bus Terminal', 'Terminal St., Sari'),
  ('Sari Railway Station', 'Railway Square, Sari'),
  ('Dasht-e Naz Airport', 'Airport Road, Sari'),
  
  -- Rasht terminals
  ('Rasht Bus Terminal', 'Terminal St., Rasht'),
  ('Rasht Railway Station', 'Railway Square, Rasht'),
  ('Sardar Jangal Airport', 'Airport Road, Rasht'),
  
  -- Gorgan terminals
  ('Gorgan Bus Terminal', 'Terminal St., Gorgan'),
  ('Gorgan Railway Station', 'Railway Square, Gorgan'),
  ('Gorgan Airport', 'Airport Road, Gorgan'),
  
  -- Ardabil terminals
  ('Ardabil Bus Terminal', 'Terminal St., Ardabil'),
  ('Ardabil Airport', 'Airport Road, Ardabil'),
  
  -- Tabriz terminals
  ('Tabriz Central Bus Terminal', 'Terminal St., Tabriz'),
  ('Tabriz Railway Station', 'Railway Square, Tabriz'),
  ('Tabriz International Airport', 'Airport Blvd, Tabriz'),
  
  -- Urmia terminals
  ('Urmia Bus Terminal', 'Terminal St., Urmia'),
  ('Urmia Airport', 'Airport Road, Urmia'),
  
  -- Zanjan terminals
  ('Zanjan Bus Terminal', 'Terminal St., Zanjan'),
  ('Zanjan Railway Station', 'Railway Square, Zanjan'),
  
  -- Sanandaj terminals
  ('Sanandaj Bus Terminal', 'Terminal St., Sanandaj'),
  ('Sanandaj Airport', 'Airport Road, Sanandaj'),
  
  -- Kermanshah terminals
  ('Kermanshah Bus Terminal', 'Terminal St., Kermanshah'),
  ('Kermanshah Railway Station', 'Railway Square, Kermanshah'),
  ('Kermanshah International Airport', 'Airport Road, Kermanshah'),
  
  -- Ilam terminals
  ('Ilam Bus Terminal', 'Terminal St., Ilam'),
  ('Ilam Airport', 'Airport Road, Ilam'),
  
  -- Hamadan terminals
  ('Hamadan Bus Terminal', 'Terminal St., Hamadan'),
  ('Hamadan Airport', 'Airport Road, Hamadan'),
  
  -- Khorramabad terminals
  ('Khorramabad Bus Terminal', 'Terminal St., Khorramabad'),
  ('Khorramabad Airport', 'Airport Road, Khorramabad'),
  
  -- Ahvaz terminals
  ('Ahvaz Bus Terminal', 'Terminal St., Ahvaz'),
  ('Ahvaz Railway Station', 'Railway Square, Ahvaz'),
  ('Ahvaz International Airport', 'Airport Blvd, Ahvaz'),
  
  -- Shahrekord terminals
  ('Shahrekord Bus Terminal', 'Terminal St., Shahrekord'),
  ('Shahrekord Airport', 'Airport Road, Shahrekord'),
  
  -- Yasuj terminals
  ('Yasuj Bus Terminal', 'Terminal St., Yasuj'),
  ('Yasuj Airport', 'Airport Road, Yasuj'),
  
  -- Isfahan terminals
  ('Isfahan Kaveh Bus Terminal', 'Kaveh St., Isfahan'),
  ('Isfahan Soffeh Bus Terminal', 'Soffeh St., Isfahan'),
  ('Isfahan Railway Station', 'Railway Square, Isfahan'),
  ('Isfahan International Airport', 'Airport Blvd, Isfahan'),
  
  -- Yazd terminals
  ('Yazd Bus Terminal', 'Terminal St., Yazd'),
  ('Yazd Railway Station', 'Railway Square, Yazd'),
  ('Yazd Shahid Sadooghi Airport', 'Airport Blvd, Yazd'),
  
  -- Shiraz terminals
  ('Shiraz Karandish Bus Terminal', 'Karandish St., Shiraz'),
  ('Shiraz Railway Station', 'Railway Square, Shiraz'),
  ('Shiraz International Airport', 'Airport Blvd, Shiraz'),
  
  -- Bushehr terminals
  ('Bushehr Bus Terminal', 'Terminal St., Bushehr'),
  ('Bushehr Airport', 'Airport Road, Bushehr'),
  
  -- Kerman terminals
  ('Kerman Bus Terminal', 'Terminal St., Kerman'),
  ('Kerman Railway Station', 'Railway Square, Kerman'),
  ('Kerman Airport', 'Airport Blvd, Kerman'),
  
  -- Bandar Abbas terminals
  ('Bandar Abbas Bus Terminal', 'Terminal St., Bandar Abbas'),
  ('Bandar Abbas Railway Station', 'Railway Square, Bandar Abbas'),
  ('Bandar Abbas International Airport', 'Airport Blvd, Bandar Abbas'),
  
  -- Zahedan terminals
  ('Zahedan Bus Terminal', 'Terminal St., Zahedan'),
  ('Zahedan Railway Station', 'Railway Square, Zahedan'),
  ('Zahedan International Airport', 'Airport Blvd, Zahedan'),
  
  -- Bojnord terminals
  ('Bojnord Bus Terminal', 'Terminal St., Bojnord'),
  ('Bojnord Airport', 'Airport Road, Bojnord'),
  
  -- Mashhad terminals
  ('Mashhad Central Bus Terminal', 'Imam Reza Blvd, Mashhad'),
  ('Mashhad Railway Station', 'Railway Square, Mashhad'),
  ('Mashhad International Airport', 'Airport Blvd, Mashhad'),
  
  -- Birjand terminals
  ('Birjand Bus Terminal', 'Terminal St., Birjand'),
  ('Birjand Airport', 'Airport Road, Birjand'),
  
  -- Jiroft terminals
  ('Jiroft Bus Terminal', 'Terminal St., Jiroft');