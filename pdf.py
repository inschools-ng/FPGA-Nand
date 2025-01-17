# Re-creating the PDF file and saving it again to resolve the download link issue.

from fpdf import FPDF

# Create instance of FPDF class
pdf = FPDF()

# Add a page
pdf.add_page()

# Set font
pdf.set_font("Arial", size=12)

# Add a title
pdf.set_font("Arial", 'B', size=14)
pdf.cell(200, 10, txt="Cover Letter", ln=True, align='C')

# Line break
pdf.ln(10)

# Add the letter content
content = [
    "[Your Name]",
    "[Your Address]",
    "[City, State, ZIP Code]",
    "[Email Address]",
    "[Phone Number]",
    "[Date]",
    "",
    "Hiring Committee",
    "[University/Organization Name]",
    "[Department/Office]",
    "[Address]",
    "[City, State, ZIP Code]",
    "",
    "Dear Members of the Hiring Committee,",
    "",
    "I am writing to express my enthusiastic interest in the Computer Technician position within the Music Technology program and MPAP classrooms. With a robust background in both IT and music technology, I am eager to leverage my skills to support the innovative and dynamic environment at your institution. This position aligns perfectly with my expertise and passion for integrating technology with creative arts.",
    "",
    "Throughout my career, I have developed a deep proficiency in troubleshooting and repairing both Mac and PC systems, including setup and networking. My hands-on experience has equipped me with the ability to assist faculty and students effectively, ensuring that all computer-related issues are resolved promptly and efficiently. I take pride in maintaining department computers, ensuring they are always up-to-date with the latest software versions, which is critical for seamless educational and creative processes.",
    "",
    "In addition to technical troubleshooting, I bring a comprehensive understanding of a wide range of software applications, including Avid, Logic, Finalcut, Filemaker, and numerous audio software and plugins. My familiarity with these tools stems from my background in audio engineering and music technology, enabling me to provide specialized IT assistance tailored to the unique needs of MPAP faculty and classroom environments. Furthermore, my experience in coding and computer engineering enhances my ability to understand and optimize complex computer systems and processes.",
    "",
    "I am particularly excited about this opportunity because of my deep-seated passion for music technology and audio engineering. My previous experience in these fields, combined with my technical skills, positions me uniquely to contribute effectively to your program. Additionally, my proficiency in soldering cables and using soldering equipment further supports my capability to handle the diverse technical demands of the role.",
    "",
    "Thank you for considering my application. I am enthusiastic about the possibility of contributing to your team and supporting the Music Technology program’s mission. I look forward to the opportunity to discuss how my background, skills, and enthusiasm align with the goals of your department.",
    "",
    "Warm regards,",
    "",
    "[Your Name]"
]

# Add content to PDF
for line in content:
    pdf.cell(200, 10, txt=line, ln=True, align='L')

# Save the PDF to a file
pdf_output_path = "/mnt/data/Computer_Technician_Cover_Letter.pdf"
pdf.output(pdf_output_path)

pdf_output_path
