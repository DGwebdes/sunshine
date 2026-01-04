import { useState } from "react";
import { Link as RouterLink } from "react-router-dom";
import { Link as ScrollLink } from "react-scroll";

const Navbar = () => {
    const [isOpen, setIsOpen] = useState(false);

    const toggleMenu = () => {
        setIsOpen(!isOpen);
    };

    return (
        <nav className="w-full py-5 px-5 md:px-15 flex justify-between items-center">
            <div className="transform transition-transform duration-500 hover:scale-110">
                <img
                    src="/logo.webp"
                    alt="logo-img"
                    width={75}
                />
            </div>
            <div className="md:hidden">
                <button
                    onClick={toggleMenu}
                    className="focus:outline-none"
                >
                    <svg
                        className="w-6 h-6"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            d={
                                isOpen
                                    ? "M6 18L18 6M6 6l12 12"
                                    : "M4 6h16M4 12h16m-7 6h7"
                            }
                        />
                    </svg>
                </button>
            </div>
            <div className="hidden md:flex gap-2 font-[Boldonse] text-sm md:tracking-widest">
                <RouterLink
                    to={"/"}
                    className="hover:text-amber-500 transform transition-all duration-500 group"
                >
                    Home
                    <span className="absolute left-0 bottom-0 w-0 h-0.5 bg-amber-500 transition-all duration-500 group-hover:w-full"></span>
                </RouterLink>
                <ScrollLink
                    to="work"
                    smooth={true}
                    duration={500}
                    offset={-30}
                    className="cursor-pointer hover:text-amber-500 transform transition-all duration-500 group"
                >
                    Services
                    <span className="absolute left-0 bottom-0 w-0 h-0.5 bg-amber-500 transition-all duration-500 group-hover:w-full"></span>
                </ScrollLink>
                <ScrollLink
                    to="about"
                    smooth={true}
                    duration={500}
                    offset={-30}
                    className="cursor-pointer hover:text-amber-500 transform transition-all duration-500 group"
                >
                    About
                    <span className="absolute left-0 bottom-0 w-0 h-0.5 bg-amber-500 transition-all duration-500 group-hover:w-full"></span>
                </ScrollLink>
                <ScrollLink
                    to="contact"
                    smooth={true}
                    duration={500}
                    offset={-30}
                    className="cursor-pointer hover:text-amber-500 transform transition-all duration-500 group"
                >
                    Contact
                    <span className="absolute left-0 bottom-0 w-0 h-0.5 bg-amber-500 transition-all duration-500 group-hover:w-full"></span>
                </ScrollLink>
            </div>
            {isOpen && (
                <div className="fixed inset-0 bg-white z-50 flex flex-col items-center justify-center text-center md:hidden font-[Boldonse]">
                    <button
                        onClick={toggleMenu}
                        className="absolute top-5 right-5 focus:outline-none"
                    >
                        <svg
                            className="w-6 h-6"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                strokeWidth="2"
                                d="M6 18L18 6M6 6l12 12"
                            />
                        </svg>
                    </button>
                    <RouterLink
                        to={"/"}
                        className="hover:text-amber-500 transform transition-all duration-500 group mb-5"
                        onClick={toggleMenu}
                    >
                        Home
                        <span className="absolute left-0 bottom-0 w-0 h-0.5 bg-amber-500 transition-all duration-500 group-hover:w-full"></span>
                    </RouterLink>
                    <ScrollLink
                        to="work"
                        smooth={true}
                        duration={500}
                        offset={-30}
                        className="cursor-pointer hover:text-amber-500 transform transition-all duration-500 group mb-5"
                        onClick={toggleMenu}
                    >
                        Services
                        <span className="absolute left-0 bottom-0 w-0 h-0.5 bg-amber-500 transition-all duration-500 group-hover:w-full"></span>
                    </ScrollLink>
                    <ScrollLink
                        to="about"
                        smooth={true}
                        duration={500}
                        offset={-30}
                        className="cursor-pointer hover:text-amber-500 transform transition-all duration-500 group mb-5"
                        onClick={toggleMenu}
                    >
                        About
                        <span className="absolute left-0 bottom-0 w-0 h-0.5 bg-amber-500 transition-all duration-500 group-hover:w-full"></span>
                    </ScrollLink>
                    <ScrollLink
                        to="contact"
                        smooth={true}
                        duration={500}
                        offset={-30}
                        className="cursor-pointer hover:text-amber-500 transform transition-all duration-500 group mb-5"
                        onClick={toggleMenu}
                    >
                        Contact
                        <span className="absolute left-0 bottom-0 w-0 h-0.5 bg-amber-500 transition-all duration-500 group-hover:w-full"></span>
                    </ScrollLink>
                </div>
            )}
        </nav>
    );
};

export default Navbar;
