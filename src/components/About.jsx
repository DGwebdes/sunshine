const About = () => {
    return (
        <section
            id="about"
            className="h-screen flex flex-col justify-center items-center border-t overflow-y-scroll md:overflow-hidden"
        >
            <div className="w-full h-[80%] md:h-[90%] md:flex p-2">
                <div className="flex-1 flex flex-col gap-5 md:gap-10 mt-5">
                    <h2 className="font-[Boldonse] text-5xl md:text-7xl justify-start">
                        Hi, I’m{" "}
                        <span className="text-amber-500">SlimShade</span>!
                    </h2>
                    <p className="md:text-xl md:w-100 md:place-self-center">
                        The heart behind [Studio Name]. This little studio is my
                        dream come true – a place where you can relax, feel
                        taken care of, and leave feeling amazing. I believe
                        beauty is all about confidence and self-care, and I pour
                        my heart into every treatment to make sure you feel your
                        best.
                    </p>
                    <div className="border rounded-2xl p-2 md:w-[50%] place-self-center  bg-violet-400 hover:bg-blue-50">
                        <p className="flex justify-evenly items-center gap-2">
                            Find out more about me{" "}
                            <span className="text-2xl hover:scale-150 transition duration-300">
                                →
                            </span>
                        </p>
                    </div>
                </div>
                <div className="flex-2 grid grid-cols-2 xl:grid-cols-3 gap-4 p-4 over">
                    {[
                        "/1.webp",
                        "/2.webp",
                        "/pexels-ma-minh-269866-2235323.webp",
                        "/pexels-tai-zatolinni-2703959-8570002.webp",
                        "/pexels-misolo-cosmetic-2588316-11179655.webp",
                    ].map((img, index) => (
                        <div
                            key={index}
                            className="overflow-hidden rounded-lg group relative"
                        >
                            <img
                                src={img}
                                alt={`collage-${index}`}
                                className="w-full h-full object-cover transform transition-transform duration-300 group-hover:scale-105 group-hover:shadow-lg"
                            />
                            <div className="absolute inset-0 flex flex-col justify-center items-center opacity-0 transition-opacity duration-300 group-hover:opacity-100">
                                <div className="w-12.5 h-12.5 rounded-full bg-amber-500 flex justify-center items-center">
                                    <span className="text-white text-2xl group-hover:cursor-pointer">
                                        →
                                    </span>
                                </div>
                                <span className="text-white text-sm">
                                    View More
                                </span>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default About;
